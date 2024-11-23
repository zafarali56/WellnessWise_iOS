import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

// MARK: - User Model
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
	
	init(id: String, fullName: String, email: String, age: String, weight: String, height: String, gender: String) {
		self.id = id
		self.fullName = fullName
		self.email = email
		self.age = age
		self.weight = weight
		self.height = height
		self.gender = gender
	}
}

enum Route: Hashable {
	case login
	case signup
	case verification
	case healthAssessment
	case home
}

// MARK: - App State Manager
@MainActor
class AppStateManager: ObservableObject {
	@Published var isAuthenticated = false
	@Published var isLoading = true
	@Published var currentUser: User?
	
	static let shared = AppStateManager()
	
	private init() {
		setupAuthListener()
	}
	
	private func setupAuthListener() {
		Auth.auth().addStateDidChangeListener { [weak self] _, user in
			guard let self = self else { return }
			
			self.isAuthenticated = user != nil
			self.isLoading = false
			
			if let user = user {
				self.fetchUserData(userId: user.uid)
			} else {
				self.currentUser = nil
			}
		}
	}
	
	private func fetchUserData(userId: String) {
		Firestore.firestore().collection("users")
			.document(userId)
			.getDocument(source: .default) { [weak self] snapshot, error in
				if let error = error {
					print("Error fetching user data: \(error.localizedDescription)")
					return
				}
				
				guard let data = snapshot?.data() else {
					print("No user data found")
					return
				}
				
				self?.currentUser = User(
					id: userId,
					fullName: data["fullName"] as? String ?? "",
					email: data["email"] as? String ?? "",
					age: data["age"] as? String ?? "",
					weight: data["weight"] as? String ?? "",
					height: data["height"] as? String ?? "",
					gender: data["gender"] as? String ?? ""
				)
			}
	}
	
	func signOut() {
		do {
			try Auth.auth().signOut()
			isAuthenticated = false
			currentUser = nil
		} catch {
			print("Error signing out: \(error.localizedDescription)")
		}
	}
}
