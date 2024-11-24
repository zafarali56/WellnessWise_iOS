import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

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
	
	enum CodingKeys: String, CodingKey {
		case id
		case fullName
		case email
		case age
		case weight
		case height
		case gender
	}
}

@MainActor
class AppStateManager: ObservableObject {
	@Published var isAuthenticated = false
	@Published var isLoading = true
	@Published var currentUser: User?
	
	static let shared = AppStateManager()
	
	private let authStateKey = "com.wellnesswise.authState"
	private let userIdKey = "com.wellnesswise.userId"
	
	private init() {
		// Load initial state
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
					self.currentUser = nil
					UserDefaults.standard.removeObject(forKey: self.userIdKey)
				}
				
				self.isLoading = false
			}
		}
	}
	
	private func restoreSession() async {
		// Check if we have a saved user ID
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
			
			self.currentUser = User(
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
	
	func signOut() {
		do {
			try Auth.auth().signOut()
			isAuthenticated = false
			currentUser = nil
			UserDefaults.standard.set(false, forKey: authStateKey)
			UserDefaults.standard.removeObject(forKey: userIdKey)
		} catch {
			print("Error signing out: \(error.localizedDescription)")
		}
	}
}
