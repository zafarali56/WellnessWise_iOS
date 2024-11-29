//
//  HealthDataViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class HealthDataViewModel: ObservableObject {
	@Published var Systolic : String = ""
	@Published var Diastolic : String = ""
	@Published var BloodSugar : String = ""
	@Published var HeartRate : String = ""
	@Published var Cholestrol : String = ""
	@Published var WaistCircumference : String = ""
	@Published var Triglycerides : String = ""
	
	@Published var errorMessage : String = ""
	@Published var isLoading : Bool = false
	var  isBpValid: Bool {
		if Systolic.isEmpty {return false}
		if Diastolic.isEmpty {return false}
		return true
	}
	var validation : Bool {
		if HeartRate.isEmpty {return false}
		if Cholestrol.isEmpty {return false}
		if WaistCircumference.isEmpty {return false}
		if Triglycerides.isEmpty {return false}
		if BloodSugar.isEmpty {return false}
		return true
	}
	
	func Submit (using navigationManager : NavigationManager){
		guard let userId = Auth.auth().currentUser?.uid else {
			errorMessage = "User not authentiated"
			return
		}
		guard isBpValid && isBpValid else {
			errorMessage = "Please fill in all the fields"
			return
		}
		errorMessage = ""
		isLoading = true
		let healthData: [String : Any] = [
			"healthData": [
				"systolic" : Systolic,
				"diastolic" : Diastolic,
				"heartRate" : HeartRate,
				"cholestrol" : Cholestrol,
				"waistCircumference" : WaistCircumference,
				"bloodSugar" : BloodSugar,
			],
			"timestamp" : FieldValue.serverTimestamp()
		]
		Firestore.firestore().collection("users")
			.document(userId)
			.collection("healthData")
			.addDocument(data: healthData){ [weak self] error in
				self?.isLoading = false
				if let error = error {
					self?.errorMessage = error.localizedDescription
				} else {
					navigationManager.switchToMain()
				}
				
			}
	
		
	}
}
