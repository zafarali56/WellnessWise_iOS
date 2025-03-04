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
                Button {
                    navigationManager.pushAuthentication(.signup)
                } label: {
                    Text("Don't have an account? Sign up")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
				
			}
			.padding(.horizontal, 30)
		}
        .toolbar{
            ToolbarItem(placement: .topBarTrailing, content: {
                ActionSection(viewModel: viewModel)
            })
        }
		.navigationTitle("Login")
		.navigationBarTitleDisplayMode(.large)
		.navigationBarBackButtonHidden()
        .alert("Error", isPresented: $viewModel.isError)
        {
            Button("OK", role: .cancel) {}
        }message: {
            Text("\(viewModel.errorMessage)")
        }
            
            
	}
}



private struct ActionSection: View {
	@EnvironmentObject private var navigationManager : NavigationManager
	@ObservedObject var viewModel: LoginViewModel
	
	var body: some View {
		VStack(spacing: 16) {

			
			Button(action: { viewModel.login(using: navigationManager) }) {
				if viewModel.isLoading {
					ProgressView()
						.tint(.white)
				} else {
					Text("Login to your account")
						.font(.headline)
						.fontWeight(.semibold)
						.foregroundStyle(.white)

				}
			}
            .buttonStyle(.borderedProminent)
            .clipShape(.capsule)
            .tint(.black)
			.disabled(viewModel.isLoading || !viewModel.isFormValid)
			
			

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
