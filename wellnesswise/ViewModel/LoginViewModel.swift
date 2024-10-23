//
//  LoginViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 20/10/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginViewModel : ObservableObject {
	@Published var email : String = ""
	@Published var password : String = ""
	
	@Published var errorMessage : String = ""
	@Published var isLoading : Bool = false
	@Published var isLoginSuccessful : Bool = false
	
	func validate () -> Bool {
		if email.isEmpty && password.isEmpty {
			errorMessage = "Fill in all the fields"
			return false
		}
		if !validEmail(email){
			errorMessage = "Invalid email"
			return false
		}
		if password.count < 6 {
			errorMessage = "Password must be 6 character or long"
			return false
		}
		errorMessage = ""
		return true
	}
	
	private func validEmail (_ email : String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPred =  NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	
	func login () {
		guard validate() else {
		return
		}
		
		isLoading = true
		errorMessage = ""
		Auth.auth().signIn(withEmail: email, password: password){
		[weak self] result, error in
			guard let self = self else {return}
			self.isLoading = false
			if let error = error {
				self.errorMessage = error.localizedDescription
				self.isLoginSuccessful = false
			}
			else {
				self.isLoginSuccessful = true
			}
		}
		
		
	}
}
