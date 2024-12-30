//
//  HealthKitManager.swift
//  wellnesswise
//
//  Created by Zafar Ali on 27/12/2024.
//

import Foundation
import HealthKit
class HealthKitManager {
	//Instance of healthKitStore
	let healthStore = HKHealthStore()
	//Requesting Authorization for HeartRate/BP/BS
	func requestAuthorization (completion: @escaping (Bool, Error?) -> Void ){
		guard let heartRateType = HKObjectType.quantityType(
			forIdentifier: .heartRate),
			  let systolicType = HKObjectType.quantityType(
				forIdentifier: .bloodPressureSystolic
			  ),
			  let diastolicType = HKObjectType.quantityType(
				forIdentifier: .bloodPressureSystolic
			  ),
			  let bloodGlucoseType = HKObjectType.quantityType(
				forIdentifier: .bloodGlucose
			  )
		else {
			completion(false, nil)
			return}
		//Adding these types to set a read permission
		let readTypes : Set<HKObjectType> = [
			heartRateType,
			systolicType,
			diastolicType,
			bloodGlucoseType
		]
		healthStore.requestAuthorization(toShare: nil, read: readTypes) {
			success,
			error in completion(success,error)
		}
	}
}
extension HealthKitManager {
	func retriveLatestHearRate (completion: @escaping (Double?, Error?) -> Void ){guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)else{completion(nil, nil)
		return}
		let sortDescription = NSSortDescriptor(
			key: HKSampleSortIdentifierStartDate,
			ascending: false
		)
		let query = HKSampleQuery (
			sampleType: heartRateType,
			predicate: nil,
			limit: 1,
			sortDescriptors: [sortDescription]
		){
			(_, samples, error) in
			if let sample = samples?.first as? HKQuantitySample {
				// Heart Rate is typically stored in count/min (beats per minute)
				let bpm = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
				completion(bpm, nil)
				
				print(bpm)
			} else {
				completion(nil, error)
			}
		}
		healthStore.execute(query)
	}
}

