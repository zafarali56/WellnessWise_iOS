//
//  HealthKitViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 30/12/2024.
//

import Foundation


class HealthKitViewModel: ObservableObject {
	private let healthKitManager = HealthKitManager()

	@Published var heartRate: Double?

	// Request authorization and fetch data
	func requestHealthKitAccess() {
		healthKitManager.requestAuthorization { [weak self] (success, error) in
			guard success else {
				print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
				return
			}
			// Now that we have permission, fetch all data
			self?.fetchAllData()
		}
	}
	
	// Fetch heart rate, BP, glucose in a single function
	private func fetchAllData() {
		fetchHeartRate()
	}
	
	 func fetchHeartRate() {
		healthKitManager.retriveLatestHearRate { [weak self] (bpm, error) in
			DispatchQueue.main.async {
				if let bpm = bpm {
					self?.heartRate = bpm
				} else {
					print("No heart rate data: \(error?.localizedDescription ?? "")")
				}
			}
		}
	}
	
}
