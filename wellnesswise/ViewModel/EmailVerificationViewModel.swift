//
//  EmailVerificationViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 16/11/2024.
//

import Foundation
import Firebase
import FirebaseAuth

class EmailVerificationViewModel : ObservableObject {
	@Published var errorMessage = ""
	@Published var isLoading = false
	@Published var isSignupSuccessful = false
	@Published var isEmailVerified = false
	@Published var showResendAlert = false
	@Published var isVerificationEmailSent = false
	
	
	init() {
		checkVerificationStatus()
	}
	
	func checkVerificationStatus() {
		guard let usr = Auth.auth().currentUser else {return}
		usr.reload {[weak self] error in
			if let error = error {
				DispatchQueue.main.async{
					self?.errorMessage = error.localizedDescription
				}
				return
			}
			DispatchQueue.main.async{
				self?.isEmailVerified	= usr.isEmailVerified
			}
		}
	}
	
	func sendVerificationEmail (){
		guard let usr = Auth.auth().currentUser else {return}
		isLoading = true
		
		usr.sendEmailVerification(){ [weak self] error in
			DispatchQueue.main.async{
				self?.isLoading = false
				if let error = error {
					self?.errorMessage = error.localizedDescription
				}
				else {
					self?.isVerificationEmailSent = true
				}
			}
			
		}
	}
	
	func startVerificationEmailCheck ()
	{
		Timer.scheduledTimer(withTimeInterval: 	5.0, repeats: true){
			[weak self] timer in
			self?.checkVerificationStatus()
		
			//Stops the timer from runloop object
			if self?.isEmailVerified == true {
				timer.invalidate()
			}
		}
	}
	
	
}
