import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct User: Codable, Identifiable {
	let id: String
	let fullName: String
	let email: String
	let age: String
	let weight: String
	let height: String
	let gender: String
}
struct HealthData: Codable, Identifiable {
	let id: String
	let bloodSugar: String
	let cholestrol: String
	let heartRate: String
	let waistCircumference: String
	let diastolic: String
	let systolic : String
}
@MainActor
class AppStateManager: ObservableObject {
	@Published var isAuthenticated = false
	@Published var isLoading = true
	@Published var currentUserData: User?
	@Published var currentUserHealthData: HealthData?
	
	static let shared = AppStateManager()
	
	private let authStateKey = "com.wellnesswise.authState"
	private let userIdKey = "com.wellnesswise.userId"
	
	private init() {
		setupInitialState()
	}
	
	private func setupInitialState() {
		isAuthenticated = UserDefaults.standard.bool(forKey: authStateKey)
		
		if let currentUser = Auth.auth().currentUser {
			isAuthenticated = true
			UserDefaults.standard.set(true, forKey: authStateKey)
			UserDefaults.standard.set(currentUser.uid, forKey: userIdKey)
			
			Task {
				await fetchUserData(userId: currentUser.uid)
				isLoading = false
			}
		} else {
			if isAuthenticated {
				Task {
					await restoreSession()
				}
			} else {
				isLoading = false
			}
		}
		
		setupAuthListener()
	}
	
	private func setupAuthListener() {
		Auth.auth().addStateDidChangeListener { [weak self] _, user in
			Task { @MainActor in
				guard let self = self else { return }
				
				let isAuth = user != nil
				self.isAuthenticated = isAuth
				UserDefaults.standard.set(isAuth, forKey: self.authStateKey)
				
				if let user = user {
					UserDefaults.standard.set(user.uid, forKey: self.userIdKey)
					await self.fetchUserData(userId: user.uid)
				} else {
					self.currentUserData = nil
					UserDefaults.standard.removeObject(forKey: self.userIdKey)
				}
				
				self.isLoading = false
			}
		}
	}
	
	private func restoreSession() async {
		if let userId = UserDefaults.standard.string(forKey: userIdKey),
		   Auth.auth().currentUser != nil {
			await fetchUserData(userId: userId)
		} else {
			isAuthenticated = false
			UserDefaults.standard.set(false, forKey: authStateKey)
			UserDefaults.standard.removeObject(forKey: userIdKey)
		}
		
		isLoading = false
	}
	
	private func fetchUserData(userId: String) async {
		do {
			let document = try await Firestore.firestore()
				.collection("users")
				.document(userId)
				.getDocument()
			
			guard let data = document.data() else {
				print("No user data found")
				return
			}
			
			self.currentUserData = User(
				id: userId,
				fullName: data["fullName"] as? String ?? "",
				email: data["email"] as? String ?? "",
				age: data["age"] as? String ?? "",
				weight: data["weight"] as? String ?? "",
				height: data["height"] as? String ?? "",
				gender: data["gender"] as? String ?? ""
			)
		} catch {
			print("Error fetching user data: \(error.localizedDescription)")
		}
	}
	private func fetchHealthData(userId: String) async {
		do {
			let document = try await Firestore.firestore()
				.collection("user/healthData")
				.document(userId)
				.getDocument()
			
			
			guard let healthData = document.data() else {
				print("No health data found")
				return
			}
			self.currentUserHealthData = HealthData(
				id: userId,
				bloodSugar : healthData["bloodSugar"] as? String ?? "",
				cholestrol : healthData["cholestrol"] as? String ?? "",
				heartRate : healthData["heartRate"] as? String ?? "",
				waistCircumference: healthData["waitCircumference"] as? String ?? "",
				diastolic : healthData ["diastolic"] as? String ?? "",
				systolic : healthData ["systolic"] as? String ?? ""
				)
		}catch {
			print("Error fetching health data : \(error.localizedDescription)")
		}
	}
	func signOut() {
		do {
			try Auth.auth().signOut()
			isAuthenticated = false
			currentUserData = nil
			currentUserHealthData = nil
			UserDefaults.standard.set(false, forKey: authStateKey)
			UserDefaults.standard.removeObject(forKey: userIdKey)
		} catch {
			print("Error signing out: \(error.localizedDescription)")
		}
	}
}
