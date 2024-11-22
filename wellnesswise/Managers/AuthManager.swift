//
//  File.swift
//  wellnesswise
//
//  Created by Zafar Ali on 22/11/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

struct User: Identifiable, Codable {
	let id : String
	let fullName : String
	let email : String
	let age : String
	let weight : String
	let height : String
	let gender : String
}

class AuthManager : ObservableObject {
	@Published var isAuthenticated = false
	@Published var currentUser : User?
	@Published var userSession: FirebaseAuth.User?
	@Published var isLoading = true
	
	static let shared = AuthManager()
	private var cancellables = Set<AnyCancellable>()
	
	private init (){
		print("AUthenticatin Manager initilized ")
		setupAuthStateListener()
	}
	
	
	private func setupAuthStateListener () {
		Auth.auth().addStateDidChangeListener{[weak self ] _, user in
			DispatchQueue.main.async{
				print ("Auth state changed. User:: \(user?.uid ?? "Nil")")
				self?.userSession = user
				self?.isAuthenticated = user != nil
				self?.isLoading = false
				
				
				if let user = user {
					self?.fetchUserData(userId: user.uid)
				}
				else {
					self?.currentUser = nil
				}
			}
		}
	}
	
	private func fetchUserData(userId: String) {
		print("Fetching user data for ID\(userId)")
		Firestore.firestore().collection("users")
			.document(userId)
			.getDocument { [weak self] snapshot, error in
				if let error = error {
					print("Error fetching user data: \(error.localizedDescription)")
					return
				}
				
				if let data = snapshot?.data() {
					let user = User(
						id: userId,
						fullName: data["fullName"] as? String ?? "",
						email: data["email"] as? String ?? "",
						age: data["age"] as? String ?? "",
						weight: data["weight"] as? String ?? "",
						height: data["height"] as? String ?? "",
						gender: data["gender"] as? String ?? ""
					)
					
					DispatchQueue.main.async {
						print("User data fetched successfully")
						self?.currentUser = user
					}
				}
			}
	}
	
	func signOut () {
		do {
			try Auth.auth().signOut()
			self.userSession = nil
			self.currentUser = nil
			self.isAuthenticated = false
		}catch {
			print("Error signing out \(error.localizedDescription)")
		}
	}
}
