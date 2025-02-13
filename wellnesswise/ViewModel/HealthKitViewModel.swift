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
				let (heartrate, systolic, diastolic, bloodglucose) = try await (
					fetchedHeartRate,
					fetchedSystolic,
					fetchedDiastolic,
					fetchedBloodGlucose
				)
				self.heartRate    = heartrate
				self.systolicBP   = systolic
				self.diastolicBP  = diastolic
				self.bloodGlucose = bloodglucose
				print("systolic currently :\(String(describing: systolicBP))")
				print("diastolic currently :\(String(describing: diastolicBP))")
				print("heartate currently :\(String (describing: heartRate))")
				print("bloodglucose currently :\(String (describing: bloodGlucose))")
			} catch {
				errorMessage = error.localizedDescription
				print("Error fetching health data: \(errorMessage ?? "Unknown error")")
			}
			isLoading = false
		}
	
}
