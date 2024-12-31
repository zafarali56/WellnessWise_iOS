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
	@MainActor
	func requestHealthKitAccess() async throws {
		try await withCheckedThrowingContinuation { continuation in
			healthKitManager.requestAuthorization { success, error in
				if success {
					continuation.resume()
				} else {
					continuation.resume(throwing: error ?? NSError(domain: "Unknown Error", code: -1, userInfo: nil))
				}
			}
		}
	}
	
	

	@MainActor
	func fetchHeartRate() async {
		do {
			let bpm = try await healthKitManager.retrieveLatestHeartRate()
			self.heartRate = bpm
		} catch {
			print("Error fetching heart rate: \(error.localizedDescription)")
		}
	}

	
}
