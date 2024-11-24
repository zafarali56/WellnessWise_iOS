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
	@State private var selectedTab : TabItem = .home
	
	var body: some View {
		ScrollView{
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
			
			.navigationTitle("Wellness wise")
			.padding()
			.navigationBarBackButtonHidden()
			.toolbar {
				ToolbarItem(placement: .bottomBar){
					CustomBottomBar(selectedTab: $selectedTab)
					
				}
			}
			
		}
	}
}
#Preview {
	HomeScreen()
		.environmentObject(AppStateManager.shared)
		.environmentObject(NavigationManager.shared)
}
