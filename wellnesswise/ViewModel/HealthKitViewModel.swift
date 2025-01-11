//
//  HealthKitViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 30/12/2024.
//

import Foundation
import HealthKit
import Firebase
import FirebaseAuth
@MainActor
class HealthKitViewModel: ObservableObject {
	private let healthKitManager = HealthKitManager()
	@Published var heartRate: Double?
	@Published var systolicBP: Double?
	@Published var diastolicBP: Double?
	@Published var bloodGlucose: Double?
	@Published var isLoading: Bool = false
	@Published var errorMessage: String?
	func fetchAllData() async {
		guard HKHealthStore.isHealthDataAvailable() else {
			errorMessage = "Health data is not available on this device."
			return
		}
		isLoading = true
		errorMessage = nil
		do {
			try await healthKitManager.requestAuthorization()
			async let fetchedHeartRate = healthKitManager.retrieveLatestHeartRate()
			async let fetchedSystolic = healthKitManager.retrieveLatestSystolic()
			async let fetchedDiastolic = healthKitManager.retrieveLatestDiastolic()
			async let fetchedBloodGlucose = healthKitManager.retrieveLatestBloodGlucose()
			let (heartRate, systolic, diastolic, bloodGlucose) = try await (
				fetchedHeartRate,
				fetchedSystolic,
				fetchedDiastolic,
				fetchedBloodGlucose
			)
			self.heartRate    = heartRate
			self.systolicBP   = systolic
			self.diastolicBP  = diastolic
			self.bloodGlucose = bloodGlucose
			

			print("systolic currently :\(systolic)")
			print("systolic currently :\(diastolic)")
			print("systolic currently :\(heartRate)")
			print("systolic currently :\(bloodGlucose)")
		} catch {
			errorMessage = error.localizedDescription
			print("Error fetching health data: \(errorMessage ?? "Unknown error")")
		}
		isLoading = false
	}
	
	func SubmitByHealthKit (using navigationManager: NavigationManager)  {
		guard let userId = Auth.auth().currentUser?.uid else {
			
			errorMessage = "User not authenticated"
			return
		}
		errorMessage = ""
		isLoading = true
		
		
		let healthData : [String: Any] = [
			"healthData":  [
				"systolic": systolicBP,
				"diastolic": diastolicBP,
				"heartRate": heartRate,
				"bloodSugar": bloodGlucose,
			],
			"timestamp" : FieldValue.serverTimestamp()
			
		]
		print(healthData)
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
