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
	@Published var healthKitViewModel : HealthKitViewModel
	
	init (healthKitViewModel: HealthKitViewModel)
	{
		self.healthKitViewModel = healthKitViewModel
	}
	
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
		if Systolic.isEmpty && Diastolic.isEmpty {return false}
		return true
	}
	var validation : Bool {
		if isBpValid == false && isTriglycerides == false && isCholestrolValid == false && isTriglycerides == false && isHearRateValid == false && isWaistCircumferenceValid == false && isBloodSugarValid == false {
			return false
		}
		return true
	}
	var isBloodSugarValid : Bool {
		if BloodSugar.isEmpty {return false}
		return true
	}
	var isHearRateValid : Bool {
		if HeartRate.isEmpty {return false}
		return true
	}
	var isCholestrolValid : Bool {
		if Cholestrol.isEmpty {return false}
		return true
	}
	var isWaistCircumferenceValid : Bool {
		if WaistCircumference.isEmpty {return false}
		return true
	}
	var isTriglycerides : Bool {
		if Triglycerides.isEmpty {return false}
		return true
	}
	
	
	func isError ()-> Bool {
		if errorMessage != "" {
			return true
		}
		else {
			return false
		}
	}
	
	@MainActor
	func SubmitManually (using navigationManager : NavigationManager){
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
	@MainActor
	func SubmitByHealthKit (using navigationManager: NavigationManager)  {
		guard let userId = Auth.auth().currentUser?.uid else {
			
			healthKitViewModel.errorMessage = "User not authenticated"
			return
		}
		healthKitViewModel.errorMessage = ""
		healthKitViewModel.isLoading = true
		
		guard let systolic = healthKitViewModel.systolicBP,
			  let diastolic = healthKitViewModel.diastolicBP,
			  let heartrate = healthKitViewModel.heartRate,
			  let bloodglucose = healthKitViewModel.bloodGlucose else {
			healthKitViewModel.errorMessage = "Values are either Null or missing"
			healthKitViewModel.isLoading = false
			return
		}
		
		print(healthKitViewModel.errorMessage ?? "")
		print("Systolic: \(systolic), Diastolic: \(diastolic), HeartRate: \(heartrate), BloodGlucose: \(bloodglucose)")
		let healthData : [String: Any] = [
			"healthData":  [
				"systolic" : healthKitViewModel.systolicBP ?? 0.0,
				"diastolic" : healthKitViewModel.diastolicBP ?? 0.0,
				"heartRate" : healthKitViewModel.heartRate ?? 0.0,
				"cholestrol" : Cholestrol ,
				"waistCircumference" : WaistCircumference,
				"bloodSugar" : healthKitViewModel.bloodGlucose ?? 0.0,
			],
			"timestamp" : FieldValue.serverTimestamp()
			
		]
		print(healthData)
		Firestore.firestore().collection("users")
			.document(userId)
			.collection("healthData")
			.addDocument(data: healthData){ [weak self] error in
				self?.healthKitViewModel.isLoading = false
				if let error = error {
					self?.healthKitViewModel.errorMessage = error.localizedDescription
				} else {
					navigationManager.switchToMain()
				}
			}
	}
	
	

}




