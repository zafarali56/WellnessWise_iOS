//
//  LoginScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 11/10/2024.
//

import SwiftUI

struct LoginScreen: View {
	@StateObject private var viewModel = LoginViewModel()
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 15) {
					LogoSection()
					
					FormSection(viewModel: viewModel)
					
					ActionSection(viewModel: viewModel)
				}
				.padding(.horizontal, 30)
			}
			.navigationTitle("Login")
			.navigationBarTitleDisplayMode(.large)
			.navigationDestination(isPresented: $viewModel.isLoginSuccessful) {
				HomeScreen()
			}
			.navigationBarBackButtonHidden()
		}
	}
}
private struct ActionSection: View {
	@ObservedObject var viewModel: LoginViewModel
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack(spacing: 16) {
			// Error Message
			if !viewModel.errorMessage.isEmpty {
				Text(viewModel.errorMessage)
					.font(.footnote)
					.foregroundStyle(.red)
					.padding(.horizontal)
					.transition(.opacity)
			}
			
			// Login Button
			Button(action: { viewModel.login() }) {
				if viewModel.isLoading {
					ProgressView()
						.tint(.white)
				} else {
					Text("Login")
						.font(.headline)
						.fontWeight(.semibold)
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity)
						.frame(height: 30)
				}
			}
			.clipShape(.capsule)
			.buttonStyle(.borderedProminent)
			.tint(.black)
			.disabled(viewModel.isLoading || !viewModel.isFormValid)
			
			// Sign Up Link
			NavigationLink {
				SignUpScreen()
			} label: {
				Text("Don't have an account? Sign up")
					.font(.subheadline)
					.fontWeight(.medium)
			}
			
		}
		.padding(.vertical)
	}
}

private struct FormSection: View {
	@ObservedObject var viewModel: LoginViewModel
	
	var body: some View {
		VStack(spacing: 16) {
			StyledTextField(
				title: "Email",
				placeholder: "Enter your email",
				text: $viewModel.email,
				isValid: viewModel.isValidEmail,
				errorMessage: "Please enter a valid email"
			)
			
			StyledTextField(
				title: "Password",
				placeholder: "Enter your password",
				text: $viewModel.password,
				isSecure: true,
				isValid: viewModel.isValidPassword,
				errorMessage: "Password must be at least 6 characters"
			)
			
			// Forgot Password Link
			NavigationLink {

			} label: {
				Text("Forgot password?")
					.font(.footnote)
					.fontWeight(.medium)
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			.padding(.top, 4)
		}
	}
}

// MARK: - Supporting Views
private struct LogoSection: View {
	var body: some View {
		Image(.whitetheme)
		.resizable()
		.scaledToFit()
	}
}

#Preview {
    LoginScreen()
}
