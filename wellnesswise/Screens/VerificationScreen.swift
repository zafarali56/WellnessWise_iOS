//
//  VerificationScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 05/11/2024.
//

import SwiftUI

struct VerificationScreen: View {
	@StateObject private var viewModel = EmailVerificationViewModel ()
	@EnvironmentObject private var navigationManager : NavigationManager

	var body: some View {
		
		VStack (spacing : 20){
			Image(systemName: "envelope")
				.font(.system(size: 70))
				.foregroundStyle(.black)
			
			Text("Please Verify Email")
				.font(.title2)
				.fontWeight(.bold)
			
			Text("Verification email will be sent your email inbox, please click on the link to verify it.")
				.multilineTextAlignment(.center)
				.foregroundStyle(.secondary)
				.padding(.horizontal)
			
			if viewModel.isLoading{
				ProgressView()
			} else {
				Button(action: {
					viewModel.sendVerificationEmail()
				}){
					Text ("Send Verification Email")
						.font(.headline)
						.foregroundStyle(.white)
						.frame(maxWidth: 250)
						.frame(height: 50)
						.background(.black)
						.clipShape(.capsule)
				}
			}
			if !viewModel.errorMessage.isEmpty {
				Text(viewModel.errorMessage)
					.foregroundStyle(.red)
					.font(.caption)
			}
		}
		.padding()
		.onAppear{
			viewModel
				.startVerificationEmailCheck(using: navigationManager)
		}
		.alert("Email Sent", isPresented: $viewModel.isVerificationEmailSent) {
			Button("OK", role: .cancel) { }
		} message: {
			Text("Please check your email inbox and verify your account.")
		}
		.navigationBarBackButtonHidden()
		.onDisappear{viewModel.cleanUp()}
	}
}

#Preview {
	VerificationScreen()
}
