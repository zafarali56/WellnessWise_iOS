import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class HealthAssessmentViewModel: ObservableObject {
	// MARK: - Medical History
	@Published var familyDiabetes: String = "no"
	@Published var heartDisease: String = "no"
	@Published var familyHistoryCancer: String = "no"
	@Published var previousSurgeries: String = "no"
	@Published var chronicDiseases: String = "no"
	
	// MARK: - Lifestyle Habits
	@Published var smoke: String = "no"
	@Published var selectedAlcoholLevel = "None"
	let alcoholConsumptionLevels = ["None", "Light", "Moderate", "Heavy", "Very Heavy"]
	
	@Published var selectedActivityLevel = "Moderate"
	let physicalActivityLevels = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
	
	@Published var selectedDietQuality: String = "Good"
	let dietQualityLevels = ["Poor", "Fair", "Good", "Very Good", "Excellent"]
	
	@Published var sleepHours: Double = 7.0
	let sleepHoursRange = 4.0...12.0
	
	// MARK: - Environmental Factors
	@Published var airQualityIndex: Double = 50.0
	let airQualityIndexRange = 1.0...500.0
	
	@Published var selectedPollutantExposure: String = "Low"
	let pollutantExposureLevels = ["Low", "Moderate", "High", "Very High"]
	
	// MARK: - Additional Information
	@Published var selectedStressLevel: String = "Moderate"
	let stressLevels = ["Low", "Mild", "Moderate", "High", "Severe"]
	
	@Published var selectedHealthcareAccess: String = "Moderate"
	let healthcareAccessLevels = ["Poor", "Limited", "Moderate", "Good", "Excellent"]
	
	// MARK: - State
	@Published var isLoading = false
	@Published var errorMessage = ""
	@Published var isAssessmentCompleted = false
	
	// MARK: - Helper Methods
	func getAirQualityColor() -> Color {
		switch airQualityIndex {
		case 0...50:
			return .green
		case 51...100:
			return .yellow
		case 101...150:
			return .orange
		case 151...200:
			return .red
		case 201...300:
			return .purple
		default:
			return .brown
		}
	}
	
	func getAirQualityDescription() -> String {
		switch airQualityIndex {
		case 0...50:
			return "Good: Safe for most people"
		case 51...100:
			return "Moderate: Acceptable"
		case 101...150:
			return "Unhealthy for Sensitive Groups"
		case 151...200:
			return "Unhealthy: Everyone may experience effects"
		case 201...300:
			return "Very Unhealthy: Health warnings"
		default:
			return "Hazardous: Health alert"
		}
	}
	
	// MARK: - Data Submission
	func submitAssessment() {
		guard let userId = Auth.auth().currentUser?.uid else {
			errorMessage = "User not authenticated"
			return
		}
		
		isLoading = true
		
		let assessmentData: [String: Any] = [
			"medicalHistory": [
				"familyDiabetes": familyDiabetes,
				"heartDisease": heartDisease,
				"familyHistoryCancer": familyHistoryCancer,
				"previousSurgeries": previousSurgeries,
				"chronicDiseases": chronicDiseases
			],
			"lifestyleHabits": [
				"smoke": smoke,
				"alcoholLevel": selectedAlcoholLevel,
				"physicalActivityLevel": selectedActivityLevel,
				"dietQuality": selectedDietQuality,
				"sleepHours": sleepHours
			],
			"environmentalFactors": [
				"airQualityIndex": airQualityIndex,
				"pollutantExposure": selectedPollutantExposure
			],
			"additionalInformation": [
				"stressLevel": selectedStressLevel,
				"healthcareAccess": selectedHealthcareAccess
			],
			"timestamp": FieldValue.serverTimestamp()
		]
		
		Firestore.firestore().collection("users")
			.document(userId)
			.collection("assessments")
			.addDocument(data: assessmentData) { [weak self] error in
				self?.isLoading = false
				
				if let error = error {
					self?.errorMessage = error.localizedDescription
				} else {
					self?.isAssessmentCompleted = true
				}
			}
	}
}
