import SwiftUI
import FirebaseAuth

struct ProfileScreen: View {
	@EnvironmentObject private var authManager: AppStateManager
	@EnvironmentObject private var navigationManager: NavigationManager
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
				.onAppear {
					Task {
						if let userId = Auth.auth().currentUser?.uid {
							await authManager
								.fetchUserData(userId: userId)
						}
					}
					
				}
			Health_Data()
				.onAppear {
					Task {
						if let userId = Auth.auth().currentUser?.uid {
							await authManager
								.fetchHealthData(userId: userId)
						}
					}
					
				}
			Assesment_Data()
				.onAppear {
					Task {
						if let userId = Auth.auth().currentUser?.uid {
							await authManager
								.fetchHealthAssesment(userId: userId)
						}
					}
					
				}

		}
		.navigationTitle("Profile")
		.padding(.horizontal)
	}
	
	private struct Personal_Data: View {
		@StateObject var appState = AppStateManager.shared
		
		var body: some View {
			VStack(spacing: 15) {
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
				VStack (spacing: 15){
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
				}				.padding()
					.background(
					 RoundedRectangle(cornerRadius: 20)
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
	
	
	
	private struct Assesment_Data: View {
		@StateObject var appState = AppStateManager.shared
		
		var body: some View {
			if let assessmentData = appState.currentHealthAssesmentData {
				VStack(spacing: 15) {
					ProfileData(
						fieldName: "Chronic Diseases",
						fieldValue: assessmentData.chronicDiseases
					)
					
					ProfileData(
						fieldName: "Family History of Diabetes",
						fieldValue: assessmentData.familyDiabetes
					)
					
					ProfileData(
						fieldName: "Family History of Cancer",
						fieldValue: assessmentData.familyHistoryCancer
					)
					
					ProfileData(
						fieldName: "Heart Disease",
						fieldValue: assessmentData.heartDisease
					)
					
					ProfileData(
						fieldName: "Previous Diseases",
						fieldValue: assessmentData.previousDisease
					)
					
					ProfileData(
						fieldName: "Previous Surgeries",
						fieldValue: assessmentData.previousSurgeries
					)
					
					ProfileData(
						fieldName: "Alcohol Level",
						fieldValue: assessmentData.alcoholLevel
					)
					
					ProfileData(
						fieldName: "Diet Quality",
						fieldValue: assessmentData.dietQuality
					)
					
					ProfileData(
						fieldName: "Physical Activity Level",
						fieldValue: assessmentData.physicalActivityLevel
					)
					
					ProfileData(
						fieldName: "Sleep Hours",
						fieldValue: "\(assessmentData.sleepHours) hours"
					)
					
					ProfileData(
						fieldName: "Smoking",
						fieldValue: assessmentData.smoke
					)
					
					ProfileData(
						fieldName: "Air Quality Index",
						fieldValue: "\(assessmentData.airQualityIndex)"
					)
					
					ProfileData(
						fieldName: "Pollutant Exposure",
						fieldValue: assessmentData.pollutantExposure
					)
					
					ProfileData(
						fieldName: "Healthcare Access",
						fieldValue: assessmentData.healthCareAcces
					)
					
					ProfileData(
						fieldName: "Stress Level",
						fieldValue: assessmentData.stresslevel
					)
					
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.white.opacity(0.8))
						.shadow(radius: 5)
				)
				.padding()
			} else {
				Text("No Health Assessment Data Found")
					.foregroundStyle(.gray)
					.multilineTextAlignment(.center)
					.padding()
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
					.multilineTextAlignment(.trailing)
			}
			.padding(.vertical, 5)
			.padding(.horizontal)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.accentColor.opacity(0.1))
			)
		}
	}
	
	struct AssesmentData_Previews: PreviewProvider {
		static var previews: some View {
			let mockAppState = AppStateManager.shared
			mockAppState.currentHealthAssesmentData = HealthAssessment(
				id: "mockId",
				chronicDiseases: "Diabetes",
				familyDiabetes: "Yes",
				familyHistoryCancer: "No",
				heartDisease: "No",
				previousDisease: "Hypertension",
				previousSurgeries: "Appendectomy",
				alcoholLevel: "Moderate",
				dietQuality: "Good",
				physicalActivityLevel: "Active",
				sleepHours: 8,
				smoke: "No",
				airQualityIndex: 45,
				pollutantExposure: "Low",
				healthCareAcces: "Excellent",
				stresslevel: "Low"
			)
			
			return Assesment_Data()
				.environmentObject(mockAppState)
		}
	}
}
#Preview {
	ProfileScreen()
}
