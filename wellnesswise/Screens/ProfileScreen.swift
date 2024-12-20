import SwiftUI

struct ProfileScreen: View {
	var body: some View {
		ScrollView {
			ProfileContents()
		}
		.navigationTitle("Profile")
		
	}
}

struct ProfileContents: View {
	@StateObject var appState = AppStateManager.shared
	
	var body: some View {
		VStack(spacing: 20) {
			if let userData = appState.currentUserData {
				Image("MyProfileWhite")
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 100)
					.clipShape(Circle())
					.overlay(
						Circle().stroke(Color.white, lineWidth: 4)
					)
					.shadow(radius: 10)
				
				VStack(spacing: 15) {
					ProfileData(fieldName: "Name", fieldValue: userData.fullName)
					ProfileData(fieldName: "Age", fieldValue: userData.age)
					ProfileData(fieldName: "Height", fieldValue: userData.height)
					ProfileData(fieldName: "Weight", fieldValue: userData.weight)
					ProfileData(fieldName: "Gender", fieldValue: userData.gender)
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.white.opacity(0.8))
						.shadow(radius: 5)
				)
				.padding()
			} else {
				Text("No user data available")
					.foregroundColor(.gray)
			}
		}
		.padding()
	}
}

struct ProfileData: View {
	var fieldName: String
	var fieldValue: String
	
	var body: some View {
		HStack {
			Text(fieldName)
				.font(.headline)
				.foregroundColor(.primary)
			Spacer()
			Text(fieldValue)
				.font(.body)
				.foregroundColor(.secondary)
		}
		.padding(.vertical, 5)
		.padding(.horizontal)
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(Color.accentColor.opacity(0.1))
		)
	}
}

#Preview {
	ProfileScreen()
}
