//
//  customBottomBar.swift
//  wellnesswise
//
//  Created by Zafar Ali on 24/11/2024.
//

import SwiftUI

enum TabItem: String, CaseIterable{
	case home, health, profile, settings
	
	var icon: String {
		switch self  {
			case .home: return "house.fill"
			case .profile: return "person.fill"
			case .settings: return "gear"
			case .health: return "heart.fill"
		}
	}
	
	var title : String {
		return self.rawValue.capitalized
	}
}

struct CustomBottomBar: View {
	@Binding var selectedTab : TabItem
	private let tabBarItems = TabItem.allCases
    var body: some View {
		HStack(){
			ForEach(tabBarItems, id: \.self){
				tab in
				Button (action: {withAnimation(.easeOut){
					selectedTab = tab
				}
				})
				{
					VStack (){
						Image(systemName: tab.icon)
							.symbolRenderingMode(.hierarchical)
							.font(.system( size: 24))
						Text(tab.title)
							.font(.caption2)
						
					}
					.foregroundStyle(selectedTab == tab ? .black : .gray)
					.frame(maxWidth: .infinity)
					.padding(10)
				}
			}
		}
		.background(.thinMaterial)

		.clipShape(RoundedRectangle(cornerRadius: 30))
		.padding(.horizontal, 10)
		.frame(maxWidth: .infinity)
    }
}

struct MainTabView: View {
	@State private var selectedTab: TabItem = .home
	
	var body: some View {
		ZStack(alignment: .bottom){
			TabView(selection: $selectedTab){
				HomeView()
					.tag(TabItem.home)
				HealthView()
					.tag(TabItem.health)
				
				ProfileView()
					.tag(TabItem.profile)
				SettingsView()
					.tag(TabItem.settings)
			}
		}
	}
}

struct HomeView : View {
	var body: some View {
		NavigationView()
		{
			Text("Home Screen")
				.navigationTitle("Home")
		}
		
	}
}

struct HealthView : View {
	var body: some View {
		NavigationView()
		{
			Text("Home Screen")
				.navigationTitle("Health")
		}
		
	}
}

struct SettingsView : View {
	var body: some View {
		NavigationView()
		{
			Text("Home Screen")
				.navigationTitle("Settings")
		}
		
	}
}

struct ProfileView : View {
	var body: some View {
		NavigationView()
		{
			Text("Home Screen")
				.navigationTitle("Profile")
		}
		
	}
}

