//
//  LoginScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 11/10/2024.
//

import SwiftUI

struct LoginScreen: View {
	@EnvironmentObject var navigationManager: NavigationManager
	@StateObject private var viewModel: LoginViewModel
	
	init() {
		_viewModel = StateObject(wrappedValue: LoginViewModel())
	}
	
	var body: some View {
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
		.navigationBarBackButtonHidden()
	}
}


private struct ActionSection: View {
	@EnvironmentObject private var navigationManager : NavigationManager
	@ObservedObject var viewModel: LoginViewModel
	
	var body: some View {
		VStack(spacing: 16) {
			if !viewModel.errorMessage.isEmpty {
				Text(viewModel.errorMessage)
					.font(.footnote)
					.foregroundStyle(.red)
					.padding(.horizontal)
					.transition(.opacity)
			}
			
			Button(action: { viewModel.login(using: navigationManager) }) {
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
			
			
			Button {
				navigationManager.pushAuthentication(.signup)
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
			VStack(spacing: 10) {
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
				
				Button {
					
				} label: {
					Text("Forgot password?")
						.font(.footnote)
						.fontWeight(.medium)
				}
				.frame(maxWidth: .infinity, alignment: .trailing)
            
            } 
		}
	}
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
