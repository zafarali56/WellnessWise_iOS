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
			VStack(spacing: 2) {
	
				Widgets()

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
struct Widgets: View {
	var body: some View {
		VStack{
			HomeWidgets(
				title: "Heart rate",
				subtitle: "40 bmp",
				imageName: "heart_rate",
				backgroundColor: Color
					.black,
				width: 70)
			HStack()
			{
				HomeWidgets(
					title: "Blood Sugar",
					subtitle: "120",
					imageName: "sugar-blood-level",
					backgroundColor: Color.black,
					width: 40
				)
				HomeWidgets(
					title: "Cholestrol",
					subtitle: "150",
					imageName: "cholesterol",
					backgroundColor: Color
						.black, width: 40
				)
			}
			HomeWidgets(
				title: "Blood pressure",
				subtitle: "120/80",
				imageName: "blood-pressure1",
				backgroundColor: Color
					.black,
				width: 70)
		}
	}
}

#Preview {
	HomeScreen()
		.environmentObject(AppStateManager.shared)
		.environmentObject(NavigationManager.shared)
}
