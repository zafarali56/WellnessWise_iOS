//
//  SignUpViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 20/10/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

class SignUpViewModel: ObservableObject {
	@Published var email = ""
	@Published var fullName = ""
	@Published var age = ""
	@Published var weight = ""
	@Published var height = ""
	@Published var gender = "Male"
	@Published var password = ""
	
	@Published var isSignupSuccessful = false
	@Published var errorMessage = ""
	@Published var isLoading = false
	
	
	
	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	
	var isValidAge: Bool {
		guard let ageInt = Int(age) else { return false }
		return ageInt >= 18 && ageInt <= 120
	}
	
	var isValidPassword: Bool {
		password.count >= 8
	}
	
	var isFormValid: Bool {
		isValidEmail &&
		!fullName.isEmpty &&
		isValidAge &&
		isValidWeight &&
		isValidHeight &&
		!gender.isEmpty &&
		isValidPassword
	}
	
	var isValidWeight : Bool {
		guard let weightValue = Double (weight) else {return false}
		return weightValue > 0 && weightValue < 500
	}
	
	var isValidHeight : Bool {
		guard let heightValue = Double (height) else {return false}
		return heightValue > 0 && heightValue < 300
	}
	
	func signup(using navigationManager : NavigationManager) {
		guard isFormValid else {
			errorMessage = "Please fill in all fields correctly"
			return
		}
		
		isLoading = true
		errorMessage = ""
		
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				if let error = error {
					self.errorMessage = error.localizedDescription
					self.isLoading = false
					return
				}
				
				if let user = result?.user {
					self.createUserProfile(user: user) { success in
						if success {
							navigationManager.pushAuthentication(.verification)
						}
					}
				}
			}
		}
	}
	
	@MainActor
	func userProfileUpdation (using navigationManager: NavigationManager){
		guard isValidAge || isValidWeight else {
			errorMessage = "Please fill the fields correctly"
			return
		}
		isLoading = true
		errorMessage = ""
		if let user = Auth.auth().currentUser{
			self.updateUserProfile(user: user){ success in
				if success {
					navigationManager.pushMain(.profile)
				}
			}
		}
	}
	
	
	private func updateUserProfile (user: FirebaseAuth.User, completion: @escaping(Bool) -> Void){
		let userData : [String : Any ] = [
			"fullName": self.fullName,
			"age" : self.age,
			"weight" : self.weight,
			"updatedAt": FieldValue.serverTimestamp()
		]
		Firestore.firestore().collection("users").document(user.uid).updateData(userData){ error in
			DispatchQueue.main.async {
				if let error = error {
					self.errorMessage = error.localizedDescription
					completion(true)
				}
				else {
					completion(false)
				}
			}
		}
	}
	
	private func createUserProfile(user: FirebaseAuth.User, completion: @escaping (Bool) -> Void) {
		let userData: [String: Any] = [
			"fullName": self.fullName,
			"age": self.age,
			"weight": self.weight,
			"height": self.height,
			"gender": self.gender,
			"createdAt": FieldValue.serverTimestamp()
		]
		
		Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
			DispatchQueue.main.async {
				self.isLoading = false
				if let error = error {
					self.errorMessage = error.localizedDescription
					completion(false)
				} else {
					completion(true)
				}
			}
		}
	}
}
