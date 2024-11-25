import SwiftUI

struct MainTabContainer: View {
	@State private var selectedTab: TabItem = .home
	@EnvironmentObject private var authManager: AppStateManager
	@EnvironmentObject private var navigationManager: NavigationManager
	
	var body: some View {
		ZStack(alignment: .bottom) {
			TabView(selection: $selectedTab) {
				NavigationView {
					HomeContent()
				}
				.tag(TabItem.home)
				
				NavigationView {
					ProfileScreen()
				}
				.tag(TabItem.profile)
				
				NavigationView {
					SettingsView()
				}
				.tag(TabItem.settings)
				
				NavigationView {
					HealthDataScreen()
				}
				.tag(TabItem.health)
			}
			
			CustomBottomBar(selectedTab: $selectedTab)
		}
	}
}

struct HomeContent: View {
	@EnvironmentObject private var authManager: AppStateManager
	@EnvironmentObject private var navigationManager: NavigationManager
	
	var body: some View {
		ScrollView {
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
		}
		.navigationTitle("Wellness Wise")
		.navigationBarBackButtonHidden()
	}
}

struct HomeScreen: View {
	var body: some View {
		MainTabContainer()
	}
}

#Preview {
	HomeScreen()
		.environmentObject(AppStateManager.shared)
		.environmentObject(NavigationManager.shared)
}
