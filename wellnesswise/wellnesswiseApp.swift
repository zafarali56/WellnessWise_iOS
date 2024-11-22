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
	@StateObject private var navigationManager = NavigationManager()
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@StateObject private var authManager = AuthManager.shared
	var body: some Scene {
		WindowGroup {
			if authManager.isLoading {
				ProgressView()
			} else if authManager.isAuthenticated{
				ContentView ()
					.environmentObject(authManager)
			}
			else {
				LoginScreen()
					.environmentObject(authManager)
			}
		}
	}
}
