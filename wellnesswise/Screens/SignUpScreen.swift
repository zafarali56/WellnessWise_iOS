import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpScreen: View {
	@EnvironmentObject private var navigationManager : NavigationManager
	@StateObject private var viewModel = SignUpViewModel()
	
	init(){
		_viewModel = StateObject(
			wrappedValue: SignUpViewModel(
			)
		)
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				FormContent(viewModel: viewModel)
				ErrorView(message: viewModel.errorMessage)
			}
			.padding()
		}
		.navigationTitle("Create Account")
		.navigationBarTitleDisplayMode(.large)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				BottomBarContent(viewModel: viewModel)
			}
		}
		.navigationBarBackButtonHidden()
	}
}
private struct FormContent: View {
	@ObservedObject var viewModel: SignUpViewModel
	
	var body: some View {
		VStack(spacing: 16) {
			Section {
				StyledTextField(
					title: "Email",
					placeholder: "Enter your email",
					text: $viewModel.email,
					isValid: viewModel.isValidEmail
				)
				
				StyledTextField(
					title: "Full Name",
					placeholder: "Enter your full name",
					text: $viewModel.fullName,
					isValid: !viewModel.fullName.isEmpty
				)
				
				HStack(spacing: 12) {
					StyledTextField(
						title: "Age",
						placeholder: "Years",
						text: $viewModel.age,
						isNumber: true,
						isValid: viewModel.isValidAge
					)
					.frame(maxWidth: .infinity)
					
					GenderPicker(selection: $viewModel.gender)
						.frame(maxWidth: .infinity)
				}
				
				HStack(spacing: 12) {
					StyledTextField(
						title: "Weight",
						placeholder: "kg",
						text: $viewModel.weight,
						isNumber: true,
						isValid: !viewModel.weight.isEmpty
					)
					.frame(maxWidth: .infinity)
					
					StyledTextField(
						title: "Height",
						placeholder: "cm",
						text: $viewModel.height,
						isNumber: true,
						isValid: !viewModel.height.isEmpty
					)
					.frame(maxWidth: .infinity)
				}
				
				StyledTextField(
					title: "Password",
					placeholder: "Create a strong password",
					text: $viewModel.password,
					isSecure: true,
					isValid: viewModel.isValidPassword
				)
				
				if !viewModel.password.isEmpty {
					PasswordStrengthIndicator(password: viewModel.password)
				}
			}
		}
		.padding(.horizontal)
	}
}


private struct BottomBarContent: View {
	@EnvironmentObject private var navigationManager: NavigationManager
	@ObservedObject var viewModel: SignUpViewModel
	
	var body: some View {
		VStack(spacing: 8) {
			Button(action: {
				viewModel.signup(using: navigationManager)
			}) {
				if viewModel.isLoading {
					ProgressView()
						.tint(.white)
				} else {
					Text("Create Account")
						.font(.headline)
						.fontWeight(.semibold)
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity)
						.frame(height: 30)
				}
			}
			.buttonStyle(.borderedProminent)
			.clipShape(.capsule)
			.tint(.black)
			.disabled(viewModel.isLoading || !viewModel.isFormValid)
			
			Button {
				navigationManager.popToRoot()
			} label: {
				Text("Already have an account? Login")
					.font(.subheadline)
					.fontWeight(.medium)
					.padding(.bottom, 10)
			}
		}
		.padding(.horizontal, 20)
	}
}
private struct GenderPicker: View {
	@Binding var selection: String
	let options = ["Male", "Female"]
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text("Gender")
				.font(.subheadline)
				.foregroundStyle(.secondary)
			
			Picker("Gender", selection: $selection) {
				ForEach(options, id: \.self) { option in
					Text(option).tag(option)
				}
			}
			.pickerStyle(.menu)
			.frame(maxWidth: .infinity)
			.frame(height: 45)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.fill(.ultraThinMaterial)
			}
		}
	}
}

private struct PasswordStrengthIndicator: View {
	let password: String
	
	private var strength: Double {
		let hasUppercase = password.contains(where: { $0.isUppercase })
		let hasLowercase = password.contains(where: { $0.isLowercase })
		let hasNumbers = password.contains(where: { $0.isNumber })
		let hasSpecialCharacters = password.contains(where: { "!@#$%^&*(),.?\":{}|<>".contains($0) })
		
		var strength = 0.0
		if hasUppercase { strength += 0.25 }
		if hasLowercase { strength += 0.25 }
		if hasNumbers { strength += 0.25 }
		if hasSpecialCharacters { strength += 0.25 }
		
		return strength
	}
	
	private var color: Color {
		switch strength {
			case 0.0..<0.5: return .red
			case 0.5..<0.6: return .orange
			case 0.6..<0.8: return .yellow
			default: return .green
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			GeometryReader { geometry in
				Rectangle()
					.fill(color)
					.frame(width: geometry.size.width * strength)
					.animation(.spring, value: strength)
			}
			.frame(height: 4)
			.background(Color.gray.opacity(0.2))
			.clipShape(RoundedRectangle(cornerRadius: 2))
			
			Text(strengthText)
				.font(.caption)
				.foregroundStyle(color)
		}
	}
	
	private var strengthText: String {
		switch strength {
			case 0.0..<0.5: return "Weak password"
			case 0.5..<0.6: return "Moderate password"
			case 0.6..<0.8: return "Safe password"
			default: return "Strong password"
		}
	}
}

private struct ErrorView: View {
	let message: String
	
	var body: some View {
		if !message.isEmpty {
			Text(message)
				.font(.footnote)
				.foregroundStyle(.red)
				.padding(.horizontal)
				.padding(.top, 4)
		}
	}
}

#Preview {
	SignUpScreen()
}
