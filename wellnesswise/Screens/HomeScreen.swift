//
//  HomeScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 21/10/2024.
//

import SwiftUI

struct HomeScreen: View {
	@EnvironmentObject private var authManager: AuthManager
	@EnvironmentObject private var navigationManager : NavigationManager
	
	var body: some View {
		VStack (spacing : 20){
			if let user = authManager.currentUser {
				Text("\(user.fullName) welcome")
			}
		}.navigationBarBackButtonHidden()
	}
}

#Preview {
	HomeScreen()
}
