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
			}
		}.navigationTitle("Settings")
	}
}

#Preview {
    SettingsScreeen()
}
