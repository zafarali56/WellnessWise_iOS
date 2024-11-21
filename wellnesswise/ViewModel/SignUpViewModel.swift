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
		
		Auth.auth().createUser(withEmail: email, password: password) {
 [weak self] result,
 error in
			guard let self = self else { return }
			
			if let error = error {
				self.errorMessage = error.localizedDescription
				self.isLoading = false
				return
			}
			
			if let user = result?.user {
				let userData: [String: Any] = [
					"fullName": self.fullName,
					"age": self.age,
					"weight": self.weight,
					"height": self.height,
					"gender": self.gender,
					"createdAt": FieldValue.serverTimestamp()
				]
				
				Firestore.firestore().collection("users").document(user.uid).setData(userData) { [weak self] error in
					guard let self = self else { return }
					self.isLoading = false
					
					if let error = error {
						self.errorMessage = error.localizedDescription
					} else {
						navigationManager
							.replaceNavigationStack(
								with: .emailVerificationScreen
							)
					}
				}
			}
		}
	}
}
