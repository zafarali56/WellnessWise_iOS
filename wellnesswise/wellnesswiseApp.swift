//
//  wellnesswiseApp.swift
//  wellnesswise
//
//  Created by Zafar Ali on 09/10/2024.
//

import FirebaseCore
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
	}
	
}
@main
struct WellnessWiseApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@StateObject private var appState = AppStateManager.shared
	@StateObject private var navigationManager = NavigationManager.shared
	
	
	var body: some Scene {
		WindowGroup {
			Group {
				if appState.isLoading {
					LoadingView()
				} else {
					RootView()
						.environmentObject(appState)
						.environmentObject(navigationManager)
				}
			}
			.onAppear {
				if appState.isAuthenticated {
					navigationManager.navigationType = .main
				} else {
					navigationManager.navigationType = .authentication
				}
			}
		}
	}
}

struct RootView: View {
	@StateObject private var navigationManager = NavigationManager.shared
	@StateObject private var appState = AppStateManager.shared
	
	var body: some View {
		Group {
			if appState.isLoading {
				LoadingView()
			} else {
				switch navigationManager.navigationType {
					case .authentication:
						AuthenticationFlow()
					case .main:
						MainFlow()
				}
			}
		}
		.environmentObject(navigationManager)
		.environmentObject(appState)
	}
}

struct AuthenticationFlow: View {
	@EnvironmentObject private var navigationManager: NavigationManager
	
	var body: some View {
		NavigationStack(path: $navigationManager.authenticationPath) {
			LoginScreen()
				.navigationDestination(for: AuthenticationRoute.self) { route in
					switch route {
						case .login:
							LoginScreen()
						case .signup:
							SignUpScreen()
						case .verification:
							VerificationScreen()
						case .healthAssessment:
							HealthAssessmentScreen()
						case .healthDataScreen:
							HealthDataScreen(
								viewModel: HealthDataViewModel(
									healthKitViewModel: HealthKitViewModel()
								)
							)
					}
				}
		}
	}
}

struct AuthenticatedView: View {
	var body: some View {
		HomeScreen()
	}
}

struct LoadingView: View {
	var body: some View {
		ProgressView()
			.scaleEffect(1.5)
	}
}
struct MainFlow: View {
	@EnvironmentObject private var navigationManager: NavigationManager
	
	var body: some View {
		NavigationStack(path: $navigationManager.mainPath) {
			HomeScreen()
				.navigationDestination(for: MainRoute.self) { route in
					switch route {
						case .home:
							HomeScreen()
						case .profile:
							ProfileScreen()
						case .healthAssessment:
							HealthAssessmentScreen(assesmentId: "existingAssessmentId")
					}
				}
		}
	}
}

extension LoginViewModel {
	@MainActor func handleSuccessfulLogin() {
		NavigationManager.shared.switchToMain()
	}
}

extension SignUpViewModel {
	@MainActor func handleSuccessfulSignUp() {
		NavigationManager.shared.pushAuthentication(.verification)
	}
}

extension EmailVerificationViewModel {
	@MainActor func handleSuccessfulVerification() {
		NavigationManager.shared.pushAuthentication(.healthAssessment)
	}
}

extension HealthAssessmentViewModel {
	@MainActor func handleSuccessfulAssessment() {
		NavigationManager.shared.pushAuthentication(.healthDataScreen)
	}
}

extension HealthDataViewModel {
	@MainActor func handleSuccessfulHealthData ()
	{
		NavigationManager.shared.switchToMain()
	}
}
