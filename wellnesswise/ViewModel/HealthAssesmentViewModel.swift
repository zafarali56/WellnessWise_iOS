import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class HealthAssessmentViewModel: ObservableObject {
	@Published var assesmentId: String?
	
	init (assesmentId: String? = nil) {
		self.assesmentId = assesmentId
		if let assesmentId = assesmentId {
			//TODO Load assesment
			loadAssesment(assesmentId: assesmentId)
		}
	}
	
	//Medical History
	@Published var familyDiabetes: String = "no"
	@Published var heartDisease: String = "no"
	@Published var familyHistoryCancer: String = "no"
	@Published var previousSurgeries: String = "no"
	@Published var chronicDiseases: String = "no"
	
	// Lifestyle Habits
	@Published var smoke: String = "no"
	@Published var selectedAlcoholLevel = "None"
	let alcoholConsumptionLevels = ["None", "Light", "Moderate", "Heavy", "Very Heavy"]
	
	@Published var selectedActivityLevel = "Moderate"
	let physicalActivityLevels = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
	
	@Published var selectedDietQuality: String = "Good"
	let dietQualityLevels = ["Poor", "Fair", "Good", "Very Good", "Excellent"]
	
	@Published var sleepHours: Double = 7.0
	let sleepHoursRange = 4.0...12.0
	
	// Environmental Factors
	@Published var airQualityIndex: Double = 50.0
	let airQualityIndexRange = 1.0...500.0
	
	@Published var selectedPollutantExposure: String = "Low"
	let pollutantExposureLevels = ["Low", "Moderate", "High", "Very High"]
	
	// Additional Information
	@Published var selectedStressLevel: String = "Moderate"
	let stressLevels = ["Low", "Mild", "Moderate", "High", "Severe"]
	
	@Published var selectedHealthcareAccess: String = "Moderate"
	let healthcareAccessLevels = ["Poor", "Limited", "Moderate", "Good", "Excellent"]
	
	// State
	@Published var isLoading = false
	@Published var errorMessage = ""
	@Published var isAssessmentCompleted = false
	
	//Helper Methods
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
	func loadAssesment (assesmentId: String)
	{
		guard let userId = Auth.auth().currentUser?.uid else {
			errorMessage = "User not authenticated"
			return
		}
		isLoading = true
		
		Firestore.firestore().collection("users")
			.document(userId)
			.collection("assessments")
			.document(assesmentId)
			.getDocument{ [weak self] snapshot, error in
				self?.isLoading = false
				
				if let error = error {
					self?.errorMessage = error.localizedDescription
					return
				}
				//if data not found
				guard let data = snapshot?.data() else {
					self?.errorMessage = "Health assesment data not found"
					return
				}
				// Populate the view model with the loaded data
				if let medicalHistory = data["medicalHistory"] as? [String: Any] {
					self?.familyDiabetes = medicalHistory["familyDiabetes"] as? String ?? "no"
					self?.heartDisease = medicalHistory["heartDisease"] as? String ?? "no"
					self?.familyHistoryCancer = medicalHistory["familyHistoryCancer"] as? String ?? "no"
					self?.previousSurgeries = medicalHistory["previousSurgeries"] as? String ?? "no"
					self?.chronicDiseases = medicalHistory["chronicDiseases"] as? String ?? "no"
				}
				
				if let lifestyleHabits = data["lifestyleHabits"] as? [String: Any] {
					self?.smoke = lifestyleHabits["smoke"] as? String ?? "no"
					self?.selectedAlcoholLevel = lifestyleHabits["alcoholLevel"] as? String ?? "None"
					self?.selectedActivityLevel = lifestyleHabits["physicalActivityLevel"] as? String ?? "Moderate"
					self?.selectedDietQuality = lifestyleHabits["dietQuality"] as? String ?? "Good"
					self?.sleepHours = lifestyleHabits["sleepHours"] as? Double ?? 7.0
				}
				
				if let environmentalFactors = data["environmentalFactors"] as? [String: Any] {
					self?.airQualityIndex = environmentalFactors["airQualityIndex"] as? Double ?? 50.0
					self?.selectedPollutantExposure = environmentalFactors["pollutantExposure"] as? String ?? "Low"
				}
				
				if let additionalInformation = data["additionalInformation"] as? [String: Any] {
					self?.selectedStressLevel = additionalInformation["stressLevel"] as? String ?? "Moderate"
					self?.selectedHealthcareAccess = additionalInformation["healthcareAccess"] as? String ?? "Moderate"
				}
			}
	}
	@MainActor
	//Data Submission
	func submitAssessment(using navigationManager : NavigationManager) {
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
		let documentReference : DocumentReference
		if let assesmentId = assesmentId {
			documentReference = Firestore.firestore().collection("users")
				.document(userId)
				.collection("assessments")
				.document(assesmentId)
		}
		else {
			documentReference = Firestore.firestore().collection("users")
				.document(userId)
				.collection("assessments")
				.document()
		}
		documentReference.setData(assessmentData) { [weak self] error in
			self?.isLoading = false
			
			if let error = error {
				self?.errorMessage = error.localizedDescription
				
			} else {
				self?.isAssessmentCompleted = true
				navigationManager.pushAuthentication(.healthDataScreen)
			}
		}
		
	}
}
