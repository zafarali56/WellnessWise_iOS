// NavigationManager.swift
import SwiftUI

enum AppScreen: Hashable {
	case loginScreen
	case signUpScreen
	case emailVerificationScreen
	case healthAssessmentScreen
	case homeScreen
}

class NavigationManager: ObservableObject {
	@Published var path = NavigationPath()
	@Published var currentScreen: AppScreen = .loginScreen

	private var screenHistory: [AppScreen] = []
	
	func navigateTo(_ screen: AppScreen) {
		currentScreen = screen
		path.append(screen)
		screenHistory.append(screen)
	}
	
	func navigateBack() {
		if !path.isEmpty {
			path.removeLast()
			screenHistory.removeLast()
			currentScreen = screenHistory.last ?? .loginScreen
		}
	}
	
	func popToRoot() {
		path = NavigationPath()
		screenHistory.removeAll()
		currentScreen = .loginScreen
	}
}
