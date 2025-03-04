import Foundation
import Firebase
import FirebaseAuth

class LoginViewModel: ObservableObject {
	@Published var email = ""
	@Published var password = ""
	
	@Published var errorMessage = ""
	@Published var isLoading = false
    @Published var isError: Bool =  false
	
	var isValidEmail: Bool? {
		if email.isEmpty { return nil }
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	
	var isValidPassword: Bool? {
		if password.isEmpty { return nil }
		return password.count >= 8
	}
	
	var isFormValid: Bool {
		isValidEmail == true && isValidPassword == true
	}
	
	func login(using navigationManager: NavigationManager) {
		guard isFormValid else {
			errorMessage = "Please fill in all fields correctly"
			return
		}
		
		isLoading = true
		errorMessage = ""
		
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				self.isLoading = false
				
				if let error = error {
					self.errorMessage = self.handleAuthError(error)
                    self.isError = true
				} else {
					navigationManager.switchToMain()
				}
			}
		}
	}
    
	private func handleAuthError(_ error: Error) -> String {
		let nsError = error as NSError
		
		switch nsError.code {
            
			case AuthErrorCode.wrongPassword.rawValue:
				return "Incorrect password. Please try again."
			case AuthErrorCode.invalidEmail.rawValue:
				return "Invalid email address."
			case AuthErrorCode.userNotFound.rawValue:
				return "No account found with this email."
			case AuthErrorCode.networkError.rawValue:
				return "Network error. Please check your connection."
			case AuthErrorCode.emailAlreadyInUse.rawValue:
				return "This email is already registered."
			case AuthErrorCode.weakPassword.rawValue:
				return "Password is too weak. Please use a stronger password."
			case AuthErrorCode.tooManyRequests.rawValue:
				return "Too many attempts. Please try again later."
			case AuthErrorCode.wrongPassword.rawValue:
				return "Wrong email or password."
 
            
			default:
				return "An error occurred. Please try again."
		}
	}
}
