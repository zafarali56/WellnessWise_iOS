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
	private var verificationTimer : Timer?


	func checkVerificationStatus() {
		guard let user = Auth.auth().currentUser else {
			errorMessage = "No authenticated user found"
			return
		}
		user.reload { [weak self] error in
			DispatchQueue.main.async {
				if let error = error {
					self?.errorMessage = error.localizedDescription
				} else {
					self?.isEmailVerified = Auth.auth().currentUser?.isEmailVerified ?? false
				}
			}
		}
	}
	func sendVerificationEmail (){
		guard let usr = Auth.auth().currentUser else {
			errorMessage = "No authenticated user found"
			return
		}
		isLoading = true
		errorMessage = ""
		usr.sendEmailVerification(){ [weak self] error in
			DispatchQueue.main.async{
				self?.isLoading = false
				if let error = error {
					self?.errorMessage = error.localizedDescription
				}
				else {
					self?.isVerificationEmailSent = true
				}}}}
	func startVerificationEmailCheck (using navigationManager: NavigationManager)
	{
		checkVerificationStatus()
		verificationTimer?.invalidate()
		verificationTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] timer in
			guard let self = self else {
				timer.invalidate()
				return
			};self.checkVerificationStatus();if self.isEmailVerified {timer.invalidate()
				DispatchQueue.main.async {
					NavigationManager.shared
						.switchToMain()
				}
			}
		}
	}
	
	func cleanUp() {
		errorMessage = ""
	isLoading = false

		verificationTimer?.invalidate()
	}
}
