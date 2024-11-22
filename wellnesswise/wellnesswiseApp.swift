//
//  wellnesswiseApp.swift
//  wellnesswise
//
//  Created by Zafar Ali on 09/10/2024.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
	}
}

@main
struct wellnesswiseApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@StateObject private var authManager = AuthManager.shared
	@StateObject private var navigationManager = NavigationManager()
	var body: some Scene {
		WindowGroup {
			RootView ()
				.environmentObject(authManager)
				.environmentObject(navigationManager)
		}
	}
}

struct RootView : View {
	@EnvironmentObject var authManager : AuthManager
	@EnvironmentObject var navigationManager : NavigationManager
	
	
	var body: some View {
		Group {
			if authManager.isLoading {
				LoadingView()
				
			}else if authManager.isAuthenticated{
				ContentView()
			}
			else {
				AuthenticationView()
			}
		}
	}
}


struct AuthenticationView : View {
	@EnvironmentObject var navigationManager : NavigationManager
	var body: some View {
		NavigationStack(path: $navigationManager.path){
			LoginScreen()
				.navigationDestination(for: AppScreen.self) {
					screen in
					switch screen {
						case .signUpScreen:
							SignUpScreen()
						case .emailVerificationScreen:
							VerificationScreen()
						default:
							EmptyView()
					}
				}
		}
	}
}

struct LoadingView: View {
	var body: some View {
		VStack{
			ProgressView()
			Text("Loading...")
				.foregroundStyle(.secondary)
				.padding(.top)
		}
	}
}
