//
//  HealthKitManager.swift
//  wellnesswise
//
//  Created by Zafar Ali on 27/12/2024.
//

import Foundation
import HealthKit

class HealthKitManager {
	let healthStore = HKHealthStore()
	func requestAuthorization() async throws {
		guard
			let heartRateType   = HKObjectType.quantityType(forIdentifier: .heartRate),
			let systolicType    = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
			let diastolicType   = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic),
			let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)
		else {
			throw NSError(domain: "Invalid HealthKit Types", code: -1, userInfo: nil)
		}
		let readTypes: Set<HKObjectType> = [
			heartRateType,
			systolicType,
			diastolicType,
			bloodGlucoseType
		]
		try await withCheckedThrowingContinuation { continuation in
			healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
				if success {
					continuation.resume(returning: ())
				} else {
					continuation.resume(
						throwing: error ?? NSError(
							domain: "HKAuthorizationError",
							code: -1,
							userInfo: [NSLocalizedDescriptionKey: "Failed to authorize HealthKit"]
						)
					)
				}
			}
		}
	}
	func retrieveLatestHeartRate() async throws -> Double {
		try await withCheckedThrowingContinuation { continuation in
			guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
				continuation.resume(
					throwing: NSError(domain: "Invalid Type", code: -1, userInfo: nil)
				)
				return
			}
			let sortDescriptor = NSSortDescriptor(
				key: HKSampleSortIdentifierStartDate,
				ascending: false
			)
			let query = HKSampleQuery(
				sampleType: heartRateType,
				predicate: nil,
				limit: 1,
				sortDescriptors: [sortDescriptor]
			) { _, samples, error in
				if let sample = samples?.first as? HKQuantitySample {
					let bpm = sample.quantity.doubleValue(
						for: HKUnit.count().unitDivided(by: .minute())
					)
					continuation.resume(returning: bpm)
				} else {
					continuation.resume(
						throwing: error ?? NSError(
							domain: "No Heart Rate Data",
							code: -1,
							userInfo: nil
						)
					)
				}
			}
			
			healthStore.execute(query)
		}
	}
	func retrieveLatestSystolic() async throws -> Double {
		try await withCheckedThrowingContinuation { continuation in
			guard let systolicType = HKQuantityType.quantityType(
				forIdentifier: .bloodPressureSystolic
			) else {
				continuation.resume(
					throwing: NSError(domain: "Invalid Type", code: -1, userInfo: nil)
				)
				return
			}
			let sortDescriptor = NSSortDescriptor(
				key: HKSampleSortIdentifierStartDate,
				ascending: false
			)
			let query = HKSampleQuery(
				sampleType: systolicType,
				predicate: nil,
				limit: 1,
				sortDescriptors: [sortDescriptor]
			) { _, samples, error in
				if let sample = samples?.first as? HKQuantitySample {
					let systolic = sample.quantity.doubleValue(for: .millimeterOfMercury())
					continuation.resume(returning: systolic)
				} else {
					continuation.resume(
						throwing: error ?? NSError(
							domain: "No Systolic Data",
							code: -1,
							userInfo: nil
						)
					)
				}
			}
			
			healthStore.execute(query)
		}
	}
	func retrieveLatestDiastolic() async throws -> Double {
		try await withCheckedThrowingContinuation { continuation in
			guard let diastolicType = HKQuantityType.quantityType(
				forIdentifier: .bloodPressureDiastolic
			) else {
				continuation.resume(
					throwing: NSError(domain: "Invalid Type", code: -1, userInfo: nil)
				)
				return
			}
			let sortDescriptor = NSSortDescriptor(
				key: HKSampleSortIdentifierStartDate,
				ascending: false
			)
			let query = HKSampleQuery(
				sampleType: diastolicType,
				predicate: nil,
				limit: 1,
				sortDescriptors: [sortDescriptor]
			) { _, samples, error in
				if let sample = samples?.first as? HKQuantitySample {
					let diastolic = sample.quantity.doubleValue(for: .millimeterOfMercury())
					continuation.resume(returning: diastolic)
				} else {
					continuation.resume(
						throwing: error ?? NSError(
							domain: "No Diastolic Data",
							code: -1,
							userInfo: nil
						)
					)
				}
			}
			
			healthStore.execute(query)
		}
	}
	func retrieveLatestBloodGlucose() async throws -> Double {
		try await withCheckedThrowingContinuation { continuation in
			guard let bloodGlucoseType = HKQuantityType.quantityType(
				forIdentifier: .bloodGlucose
			) else {
				continuation.resume(
					throwing: NSError(domain: "Invalid Type", code: -1, userInfo: nil)
				)
				return
			}
			let sortDescriptor = NSSortDescriptor(
				key: HKSampleSortIdentifierStartDate,
				ascending: false
			)
			let query = HKSampleQuery(
				sampleType: bloodGlucoseType,
				predicate: nil,
				limit: 1,
				sortDescriptors: [sortDescriptor]
			) { _, samples, error in
				if let sample = samples?.first as? HKQuantitySample {
					let glucose = sample.quantity.doubleValue(for: HKUnit(from: "mg/dL"))
					continuation.resume(returning: glucose)
				} else {
					continuation.resume(
						throwing: error ?? NSError(
							domain: "No Blood Glucose Data",
							code: -1,
							userInfo: nil
						)
					)
				}
			}
			healthStore.execute(query)
		}
	}
	
	
	
}
