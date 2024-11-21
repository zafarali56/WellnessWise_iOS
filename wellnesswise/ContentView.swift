//
//  ContentView.swift
//  wellnesswise
//
//  Created by Zafar Ali on 09/10/2024.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var navigationManager = NavigationManager()
	var body: some View {
		NavigationStack(path: $navigationManager.path){
			startingView
				.navigationDestination(for: AppScreen.self)
			{screen in
				viewForScreen(screen)
				
			}
			
			
		}
		.environmentObject(navigationManager)
	}
	@ViewBuilder
	private var startingView: some View {
		switch navigationManager.currentScreen {
			case .loginScreen:
				LoginScreen()
			case .signUpScreen:
				SignUpScreen()
			case .emailVerificationScreen:
				VerificationScreen()
			case .healthAssessmentScreen:
				HealthAssessmentScreen()
			case .homeScreen:
				HomeScreen()
			case .profileScreen:
				ProfileScreen()
			case .healthDataScreen:
				HealthDataScreen()
		}
	}
	
	@ViewBuilder
	private func viewForScreen(_ screen: AppScreen) -> some View {
		switch screen {
		case .loginScreen:
			LoginScreen()
		case .signUpScreen:
			SignUpScreen()
		case .emailVerificationScreen:
			VerificationScreen()
		case .healthAssessmentScreen:
			HealthAssessmentScreen()
		case .homeScreen:
			HomeScreen()
			case .profileScreen:
				ProfileScreen()
			case .healthDataScreen:
				HealthDataScreen()
		}
	}
}

#Preview {
    ContentView()
}
