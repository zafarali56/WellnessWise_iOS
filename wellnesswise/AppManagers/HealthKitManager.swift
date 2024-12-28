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
		return
		}
	}
}
