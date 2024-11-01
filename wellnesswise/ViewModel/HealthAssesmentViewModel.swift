//
//  HealthAssesmentViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import Foundation


class HealthAssesmentViewModel : ObservableObject {
	
	//Medical History
	@Published var familyDiabetes : String = ""
	@Published var heartDisease : String = ""
	@Published var familyHistoryCancer : String = ""
	@Published var previousSurgeries : String = ""
	@Published var choricDiseases : String = ""
	
	//LifeStyle habits
	@Published var smoke : String = ""
	@Published var alcoholConsumptionLevel : String = ""
	@Published var physicalActivity : String = ""
	@Published var dietQuality : String = ""
	@Published var sleepHour : String = ""
	
	//Envirnomental Factors
	@Published var airQuality : String = ""
	@Published var pollutantExposure : String = ""
	
	//Additional Information
	@Published var stressLevel : String = ""
	@Published var AccessToHealthCare : String = ""
	
}
