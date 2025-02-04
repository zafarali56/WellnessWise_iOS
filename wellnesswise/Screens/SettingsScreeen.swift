//
//  SettingsScreeen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 27/11/2024.
//

import SwiftUI

struct SettingsScreeen: View {
	@EnvironmentObject private var navigationManager: NavigationManager
	@EnvironmentObject private var appStateManager: AppStateManager
	
	@State private var showDeleteConfirmation = false
	@State private var email = ""
	@State private var password = ""

	var body: some View {
		NavigationView(){
			VStack{
				Button("Sign Out") {
					Task { @MainActor in
						appStateManager.signOut()
						NavigationManager.shared.switchToAuth()
					}
				}
				.buttonStyle(.borderedProminent)

				Button("Delete Account") {
					showDeleteConfirmation = true
				}
				
			}
			// Show a confirmation sheet when "Delete Account" is tapped
			.sheet(isPresented: $showDeleteConfirmation) {
				deleteAccountView(
					email: $email,
					password: $password,
					onDelete: {
						appStateManager.deleteUser(
							email: email,
							password: password,
							using: navigationManager
						)
					},
					onCancel: {
						showDeleteConfirmation = false
					}
				)
			}
			
		}.navigationTitle("Settings")
	}
}

#Preview {
	SettingsScreeen()
}


struct deleteAccountView : View {
	@Binding var email : String
	@Binding var password : String
	var onDelete: () -> Void
	var onCancel: () -> Void
	var body: some View {
		NavigationView()
		{
			VStack{
				Text("Delete Account")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding(.top, 20)
				
				Text("Are you sure you want to delete your account? This action cannot be undone.")
					.multilineTextAlignment(.center)
					.foregroundColor(.secondary)
					.padding(.horizontal)
				
				TextField("Email", text: $email)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
					.padding(.horizontal)
				
				SecureField("Password", text: $password)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding(.horizontal)
				
				HStack(spacing: 20) {
					Button("Cancel") {
						onCancel()
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.gray.opacity(0.2))
					.cornerRadius(10)
					Button("Delete", role: .destructive) {
						onDelete()
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.red)
					.foregroundColor(.white)
					.cornerRadius(10)
				}
				.padding(.horizontal)
				Spacer()
			}
			.padding()
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Close") {
						onCancel()
					}
				}
			}
		}
	}
}
