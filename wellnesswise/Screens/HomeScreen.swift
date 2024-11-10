//
//  HomeScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 21/10/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
		
		NavigationStack {
			VStack {
				Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
			}.navigationBarBackButtonHidden()
		}
	}
}

#Preview {
    HomeScreen()
}
