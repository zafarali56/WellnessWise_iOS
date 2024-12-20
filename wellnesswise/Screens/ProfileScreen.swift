//
//  ProfileScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 05/11/2024.
//

import SwiftUI

struct ProfileScreen: View {
	var body: some View {
		NavigationView(){
			ScrollView{
				ProfileContents()
			}
		}
		.navigationTitle("Profile")

	}
}

struct ProfileContents: View {
	@StateObject var appState = AppStateManager.shared
	var body: some View {
		VStack {
			if let userData = appState.currentUserData{
				Image("MyProfileWhite")
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 50)
					.shadow(radius: 10)
				VStack{
					ProfileData(fieldName: "Name",fieldValue: userData.fullName)
					ProfileData(fieldName: "Age", fieldValue: userData.age)
					ProfileData(fieldName: "Height",fieldValue: userData.height)
					ProfileData(fieldName: "Weight", fieldValue: userData.weight)
					ProfileData(fieldName: "Gender",fieldValue: userData.gender)
					
				}.font(.headline)
					.foregroundStyle(.background)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.secondary)
							.shadow(radius: 5)
					)
			}
		}}
}

struct ProfileData : View {
	var fieldName : String
	var fieldValue: String
	var body: some View {
		VStack{
			HStack{
				Text(fieldName)
				Text(":")
				Text(fieldValue)
			}
			
		}
	}
}

#Preview {
	ProfileScreen()
}
