//
//  HealthDataScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import SwiftUI

struct HealthDataScreen: View {
	var body: some View {
		ScrollView{
			VStack(spacing: 15){
				Text("Hello world")
			}
		}
		.navigationTitle("Health Data")
		.navigationBarTitleDisplayMode(.large)
		.navigationBarBackButtonHidden()
	}
}

#Preview {
    HealthDataScreen()
}
