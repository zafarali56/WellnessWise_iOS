//
//  HealthAssesmentViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HealthAssesmentViewModel : ObservableObject {
	
	//Medical History
	@Published var familyDiabetes : String = "no"
	@Published var heartDisease : String = "no"
	@Published var familyHistoryCancer : String = "no"
	@Published var previousSurgeries : String = "no"
	@Published var chronicDiseases : String = "no"
	
	//LifeStyle habits
	@Published var smoke : String = "no"
	@Published var selectedAlcholoLevel = "None"
	let AlcholoConsumptionLevel = ["None", "Light", "Moderate", "Heavy", "Very Heavy"]
	
	@Published var selectedPhysicalActivityLevel = "Moderate"
	let physicalActivityLevel = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
	
	
	@Published var selectedDietQuality : String = "Good"
	let dietQualityLevel = ["Poor", "Fair", "Good", "Very Good", "Excellent"]
	
	@Published var sleepHour : String = ""
	
	//Envirnomental Factors
	@Published var airQuality : String = ""
	@Published var pollutantExposure : String = ""
	
	//Additional Information
	@Published var stressLevel : String = ""
	@Published var AccessToHealthCare : String = ""
	
	
	@Published var isLoading = false
	@Published var errorMessage = ""
	@Published var isAssesmentCompleted = false
	
	
	func submitAssesment () {
		guard let userId = Auth.auth().currentUser?.uid else {
			errorMessage = "User not authenticated"
			return
		}
		
		var isLoading = true
		
		
		let assessmentData: [String: Any] = [
			"medicalHistory": [
				"familyDiabetes" : familyDiabetes,
				"heartDisease" : heartDisease,
				"familyHistoryCancer" : familyHistoryCancer,
				"previousSurgeries" : previousSurgeries,
				"chronicDiseases" : chronicDiseases
			],
			
			"lifeStyleHabits" : [
				"smoke" : smoke,
				"alcoholLevel" : selectedAlcholoLevel,
				"physicalActivityLevel" : physicalActivityLevel,
				"dietQuality" : selectedDietQuality
			],
			"timeStamp": FieldValue.serverTimestamp()
		]
		Firestore.firestore().collection("users")
			.document(userId)
			.collection("assesments")
			.addDocument(data: assessmentData) {[weak self] error in
				self?.isLoading = false
				
				if let error = error{
					self?.errorMessage = error.localizedDescription
				}
				else {
					self?.isAssesmentCompleted = true
				}
			}
	}
	
}

