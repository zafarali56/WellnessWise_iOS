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
				Button("Delete" , role: .destructive){
					appStateManager.deleteUser(using: navigationManager)
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
