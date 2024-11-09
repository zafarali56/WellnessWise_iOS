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
	
	@Published var errorMessage = ""
	@Published var isLoading = false
	@Published var isSignupSuccessful = false
	
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
		!weight.isEmpty &&
		!height.isEmpty &&
		!gender.isEmpty &&
		isValidPassword
	}
	
	func signup() {
		guard isFormValid else {
			errorMessage = "Please fill in all fields correctly"
			return
		}
		
		isLoading = true
		errorMessage = ""
		
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
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
						self.isSignupSuccessful = true
					}
				}
			}
		}
	}
}
