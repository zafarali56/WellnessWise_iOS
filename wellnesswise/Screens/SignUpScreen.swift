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
	@State private var isLoading = false
	
	var body: some View {
		NavigationStack() {
			VStack() {
				Text("Create account").font(.title2)
				Form{
					Section(header: Text("Personal information")){
						TextField(
							"Email",
							text:$viewModel.email
						)
						.textInputAutocapitalization(.never)
						.disableAutocorrection(true)
						.font(.title3)
						
						TextField (
							"Full Name",
							text:$viewModel.fullName
						)
						.autocorrectionDisabled(true)
						.font(.title3)
						
						
						TextField (
							"Age",
							text: $viewModel.age
						)
						.keyboardType(.numberPad)
						.font(.title3)
						
						TextField (
							"Weight (kg)",
							text: $viewModel.weight
						)
						.keyboardType(.numberPad)
						.font(.title3)
						
						TextField (
							"Height (cm)",
							text: $viewModel.height
						)
						.keyboardType(.numberPad)
						.font(.title3)
						
						Picker (selection: $viewModel.gender, label : Text ("Gender")) {
							Text("Male").tag(1)
							Text("Female").tag(2)
						}.pickerStyle(.palette)
						
						SecureField(
							"Create a Password",
							text: $viewModel.password
						)
						.autocorrectionDisabled(true)
						.font(.title3)
						
						
						
						
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
				.disabled(isLoading)
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
