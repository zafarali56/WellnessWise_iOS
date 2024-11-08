//
//  SignUpScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 17/10/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct SignUpScreen: View {
	@StateObject private var viewModel = SignUpViewModel()

	
	var body: some View {
		NavigationStack() {
			VStack() {
				Form{
					Section(header: Text("Personal information")){
						
						StyledTextField(
							title: "Email",
							placeholder: "Enter your email",
							text: $viewModel.email
						)
						StyledTextField(
							title: "Name",
							placeholder: "Enter your full name",
							text: $viewModel.fullName
						)
						StyledTextField(
							title: "Age",
							placeholder: "Please enter your age",
							text: $viewModel.age
						)
						StyledTextField(
							title: "Weight",
							placeholder: "(kg)",
							text: $viewModel.weight,
							isNumber: true
						)
						StyledTextField(
							title: "Height",
							placeholder: "(cm)",
							text: $viewModel.height,
							isNumber: true
						)
						Picker (
							"Select Gender",selection: $viewModel.gender
						) {
							ForEach(viewModel.genderType, id: \.self)
							{
								Text($0)
							}
						}.pickerStyle(.palette)
						
						StyledTextField(
							title: "Password",
							placeholder: "Please create strong password",
							text: $viewModel.password,
							isSecure: true
						)
					}
					
				}
				.navigationTitle("Create account")
				.toolbar {
					ToolbarItem(placement: .bottomBar) {
						VStack(spacing: 1) { // Add spacing between elements
							Button(action: {
								viewModel.signup()
							}) {
								if viewModel.isLoading {
									ProgressView()
								} else {
									Text("Create an account")
										.font(.subheadline)
										.fontWeight(.semibold)
										.foregroundStyle(.white)
										.frame(width: 250, height: 40)
										.background(.black)
										.clipShape(.capsule)
								}
							}
							.disabled(viewModel.isLoading)
							
							NavigationLink {
								LoginScreen()
							} label: {
								Text("Already have account? Login")
									.font(.footnote)
									.fontWeight(.semibold)
							}
						}
						.frame(maxWidth: .infinity)
					}
				}
				if !viewModel.errorMessage.isEmpty {
					Text(viewModel.errorMessage)
						.foregroundStyle(.red)
						.font(.footnote)
						.padding()
				}

				
			}
			.navigationDestination(isPresented: $viewModel.isSignupSuccessful){
				HealthAssessmentScreen()
			}
			.navigationBarBackButtonHidden()
			
		}
		
	}
}
#Preview {
	SignUpScreen()
}
