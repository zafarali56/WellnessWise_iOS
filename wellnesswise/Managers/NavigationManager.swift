// NavigationManager.swift
import SwiftUI

enum AppScreen: Hashable {
	case loginScreen
	case signUpScreen
	case emailVerificationScreen
	case healthAssessmentScreen
	case homeScreen
	case profileScreen
	case healthDataScreen
	
	var title: String {
		switch self {
		case .loginScreen: return "Login"
		case .signUpScreen: return "Sign Up"
		case .emailVerificationScreen: return "Verify Email"
		case .healthAssessmentScreen: return "Health Assessment"
		case .homeScreen: return "Home"
		case .profileScreen: return "Profile"
		case .healthDataScreen: return "Health Data"
		}
	}
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
	
	func replaceNavigationStack(with screen: AppScreen) {
		path = NavigationPath()
		screenHistory.removeAll()
		navigateTo(screen)
	}
}
