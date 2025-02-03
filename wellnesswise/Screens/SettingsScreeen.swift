//
//  SettingsScreeen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 27/11/2024.
//

import SwiftUI

struct SettingsScreeen: View {
	@EnvironmentObject private var navigationManager : NavigationManager
	@EnvironmentObject private var appStateManager : AppStateManager
	@State private var showDeleteComformations = false
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
					showDeleteComformations = true
				}
				
			}.alert(
				"Delete Account",
				isPresented: $showDeleteComformations
			){
				TextField("Email", text: $email)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				
				TextField("Email", text: $password)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				
				Button("Delete" , role: .destructive){
					appStateManager
						.deleteUser(
							email:email,
							password:password,
							using: navigationManager
						)
				}
				Button ("Cancel", role: .cancel) {
					showDeleteComformations = false
				}
			}message: {
				Text("Are you sure you want to delete your account? This action cannot be undone.")
			}
			
		}.navigationTitle("Settings")
	}
}

#Preview {
	SettingsScreeen()
}
