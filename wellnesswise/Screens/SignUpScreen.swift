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
			Text("Create account").font(.title2)
			
			VStack() {
				VStack(alignment: .center, spacing: 15){
					
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
					
					
					Button {
						Auth
							.auth()
							.createUser(
								withEmail: viewModel.email,
								password: viewModel.password
							) {
							result , error in
							if let  error = error {
								print("login Error", error.localizedDescription)
							}
						}
					}
					label: {
						Text("Create account")
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(.white)
							.frame(width:250, height: 50)
							.background(.black)
							.clipShape(.capsule)
					}
					
				}.textFieldStyle(.roundedBorder).padding(25)
				Spacer()
				
			}
			NavigationLink {
				LoginScreen()
			} label:
			{
				Text("Already have account? Login")
					.font(.footnote)
					.fontWeight(.semibold)
				
			}
		}
		
	}
	
}

#Preview {
	SignUpScreen()
}
