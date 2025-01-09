//
//  HealthKitViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 30/12/2024.
//

import Foundation
import HealthKit

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
	
	
	
	
}

struct kitFetchedData: Codable {
	let id : String
	var _heartRate : Double
	var _diastolic : Double
	var _systolic : Double
	var _bloodglucose : Double
}
