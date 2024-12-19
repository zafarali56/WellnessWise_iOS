import SwiftUI
import FirebaseAuth

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
			VStack(spacing: 2) {
	
				Widgets()
					.onAppear {
						Task {
							if let userId = Auth.auth().currentUser?.uid {
								await authManager.fetchHealthData(userId: userId)
							}
						}
					}

			}
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
struct Widgets: View {
	@StateObject var appState = AppStateManager.shared
	var body: some View {
		VStack{
			if let healthData = appState.currentUserHealthData{
				HomeWidgets(
					title: "Heart rate",
					subtitle: "\(healthData.heartRate) -/Bpm",
					imageName: "heart_rate",
					backgroundColor: Color.red,
					width: 40)
				HStack()
				{
					HomeWidgets(
						title: "Blood Sugar",
						subtitle: "\(healthData.bloodSugar)",
						imageName: "sugar-blood-level",
						backgroundColor: Color.blue,
						width: 40
					)
					HomeWidgets(
						title: "Cholestrol",
						subtitle: "\(healthData.cholestrol)",
						imageName: "cholesterol",
						backgroundColor: Color.green,
						width: 40
					)
				}
				HomeWidgets(
					title: "Blood pressure",
					subtitle: "\(healthData.bloodPressure)",
					imageName: "blood-pressure1",
					backgroundColor: Color.purple,
					width: 40)
			}
		}
		.padding()
	}
}

#Preview {
	HomeScreen()
		.environmentObject(AppStateManager.shared)
		.environmentObject(NavigationManager.shared)
}
