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
				Text("Create account").font(.title2)
				Form{
					Section(header: Text("Personal information")){
						
						StyledTextField(
							title: "Email",
							placeholder: "Please enter your email",
							text: $viewModel.email
						)
						
						StyledTextField(
							title: "Name",
							placeholder: "Please enter your full name",
							text: $viewModel.fullName
						)

						
						StyledTextField(
							title: "Age",
							placeholder: "Please enter your age",
							text: $viewModel.age
						)
						StyledTextField(
							title: "Weight",
							placeholder: "Please enter your weight (kg)",
							text: $viewModel.weight,
							isNumber: true
						)
						StyledTextField(
							title: "Height",
							placeholder: "Please enter your height (cm)",
							text: $viewModel.height,
							isNumber: true
						)
						Picker (selection: $viewModel.gender, label : Text ("Gender")) {
							Text("Male").tag(1)
							Text("Female").tag(2)
						}.pickerStyle(.palette)
						
						StyledTextField(
							title: "Password",
							placeholder: "Please create your password",
							text: $viewModel.password,
							isSecure: true
						)
					}
					
				}
				if !viewModel.errorMessage.isEmpty {
					Text(viewModel.errorMessage)
						.foregroundStyle(.red)
						.font(.footnote)
						.padding()
				}
				Button (action:{
					viewModel.signup()
				}){
					if viewModel.isLoading{
						ProgressView()
					}
					else {
						Text("Create account")
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(.white)
							.frame(width:250, height: 50)
							.background(.black)
							.clipShape(.capsule)
					}
				}
				.disabled(viewModel.isLoading)
				NavigationLink {
					LoginScreen()
				} label:
				{
					Text("Already have account? Login")
						.font(.footnote)
						.fontWeight(.semibold)
				}
				
			}
			.navigationDestination(isPresented: $viewModel.isSignupSuccessful){
				HomeScreen()
			}
			
		}
		
	}
}
#Preview {
	SignUpScreen()
}
