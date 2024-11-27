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
					SettingsScreeen()
				}
				.tag(TabItem.settings)
				
				NavigationView {
					HealthScreen()
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
					

				} else {
					ProgressView()
				}
			}
			.padding()
		}
		.navigationTitle("Home")
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
