//
//  HealthDataViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import Foundation



class HealthDataViewModel: ObservableObject {
	@Published var Systolic : String = ""
	@Published var Diastolic : String = ""
	@Published var HeartRate : String = ""
	@Published var Cholestrol : String = ""
	@Published var WaistCircumference : String = ""
	@Published var Triglycerides : String = ""

	
	
	var  isBpValid: Bool {
		return false
	}
	
	
}
