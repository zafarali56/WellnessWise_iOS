import SwiftUI

struct ProfileScreen: View {
	var body: some View {
		ScrollView {
			Image("MyProfileWhite")
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 100)
				.clipShape(Circle())
				.overlay(
					Circle().stroke(Color.white, lineWidth: 4)
				)
				.shadow(radius: 10)
			Personal_Data()
			Health_Data()

		}
		.navigationTitle("Profile")
		.padding(.horizontal)
	}
}

private struct Personal_Data: View {
	@StateObject var appState = AppStateManager.shared
	
	var body: some View {
		VStack(spacing: 10) {
			if let userData = appState.currentUserData {
				
				VStack(spacing: 15) {
					ProfileData(fieldName: "Name", fieldValue: userData.fullName)
					ProfileData(fieldName: "Age", fieldValue: "\(userData.age) -/years")
					ProfileData(fieldName: "Height", fieldValue: "\(userData.height) -/cm")
					ProfileData(fieldName: "Weight", fieldValue: "\(userData.weight) -/kg")
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
					.foregroundStyle(.gray)
			}
		}
	}
}

private struct Health_Data : View {
	@StateObject var appState = AppStateManager.shared
	var body: some View {
		if let healthData = appState.currentUserHealthData {
			VStack (spacing: 10){
				ProfileData	(
					fieldName: "Blood Pressure",
					fieldValue: "\(healthData.bloodPressure)"
				)
				ProfileData(
					fieldName: "Blood Sugar",
					fieldValue: "\(healthData.bloodSugar)"
				)
				ProfileData(
					fieldName: "Cholestrol",
					fieldValue: "\(healthData.cholestrol)"
				)
				ProfileData(
					fieldName: "Waist Circumference",
					fieldValue: "\(healthData.waistCircumference)"
				)
				ProfileData(
					fieldName: "Heart Rate",
					fieldValue: "\(healthData.heartRate)"
				)
			}.padding()
				.background(RoundedRectangle(cornerRadius: 20)
					.fill(Color.white.opacity(0.8))
					.shadow(radius: 5)
				)
				.padding()
		}
		else{
			Text("No Health Data Found")
				.foregroundStyle(.gray)
		}
	}
}

private struct ProfileData: View {
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
