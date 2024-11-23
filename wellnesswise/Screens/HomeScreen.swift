//
//  HomeScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 21/10/2024.
//

import SwiftUI
struct HomeScreen: View {
	@EnvironmentObject private var authManager: AppStateManager
	@EnvironmentObject private var navigationManager: NavigationManager
	
	var body: some View {
		VStack(spacing: 20) {
			if let user = authManager.currentUser {
				Text("Welcome, \(user.fullName)")
					.font(.title2)
				
				Button("Sign Out") {
					Task { @MainActor in
						authManager.signOut()
						NavigationManager.shared.switchToAuth()
					}
				}
				.buttonStyle(.borderedProminent)
			} else {
				ProgressView()
			}
		}
		.padding()
		.navigationBarBackButtonHidden()
	}
}

#Preview {
	HomeScreen()
		.environmentObject(AppStateManager.shared)
		.environmentObject(NavigationManager.shared)
}
