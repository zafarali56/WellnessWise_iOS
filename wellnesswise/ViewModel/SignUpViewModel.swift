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

class SignUpViewModel : ObservableObject {
	@Published var email: String = ""
	@Published var fullName: String = ""
	@Published var age : String = ""
	@Published var weight: String = ""
	@Published var height: String = ""
	@Published var gender: Int = 1
	@Published var password: String = ""
	
	
	@Published var errorMessage : String = ""
	@Published	var isSignupSuccessful : Bool = false
	
	func validate () -> Bool
	{
		if !email.isEmpty && !fullName.isEmpty && !age.isEmpty && !weight.isEmpty && !height.isEmpty && !password.isEmpty {
			errorMessage = "Please fill in all the fields"
			return false
		}
		if !isValidEmail (email) {
			errorMessage = "Please enter valid email"
		}
		
		if password.count < 6 {
			errorMessage = "Password must be 6 Character or long"
		}
		
		errorMessage = ""
		return true
		
	}
	private func isValidEmail (_ email : String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPred =  NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	func signup () {
		guard validate () else {
			return
		}
		Auth.auth().createUser(withEmail: email, password: password){[weak self] result, error in
			guard let self = self else {return}
			if let error = error {
				self.errorMessage = error.localizedDescription
				return
			}
			if let user = result?.user {
				let userData : [String: Any] = [
					"fullName" :self.fullName,
					"age" : self.age,
					"height" : self.height,
					"weight" : self.weight,
					"gender" : self.gender
				]
				Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
					if let error = error {
						self.errorMessage = error.localizedDescription
						self.isSignupSuccessful = false
					}
					else {
						self.isSignupSuccessful = true
					}
				}
			}
			

		}
		
	}
}
