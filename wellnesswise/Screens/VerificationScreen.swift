//
//  VerificationScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 05/11/2024.
//

import SwiftUI

struct VerificationScreen: View {
	@StateObject private var viewModel = EmailVerificationViewModel ()
	@Environment(\.dismiss) private var dismiss
	var body: some View {
		NavigationStack {
			VStack(){
				VStack (spacing : 20){
					Image(systemName: "envelope.circle.fill")
						.font(.system(size: 70))
						.foregroundStyle(.black)
					
					Text("Please Verify Email")
						.font(.title2)
						.fontWeight(.bold)
					
					Text("We've sent a verification email to your registered email address. Please verify to continue.")
						.multilineTextAlignment(.center)
						.foregroundStyle(.secondary)
						.padding(.horizontal)
					
					if viewModel.isLoading{
						ProgressView()
					} else {
						Button(action: {
							viewModel.sendVerificationEmail()
						}){
							Text ("Resend Verification Email")
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
					viewModel.startVerificationEmailCheck()
				}
				
				.onChange(of: viewModel.isEmailVerified) { newValue in
					if newValue {
						dismiss()
					}
				}
				
				.alert("Email Sent", isPresented: $viewModel.isVerificationEmailSent) {
					Button("OK", role: .cancel) { }
				} message: {
					Text("Please check your email inbox and verify your account.")
				}
			}
		}
	}
}

#Preview {
	VerificationScreen()
}
