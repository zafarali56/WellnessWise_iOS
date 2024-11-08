import SwiftUI

struct HealthAssessmentScreen: View {
	@StateObject private var viewModel = HealthAssessmentViewModel()
	
	var body: some View {
		NavigationStack {
			FormContent(viewModel: viewModel)
				.navigationTitle("Health Assessment")
				.toolbar {
					ToolbarItem(placement: .bottomBar) {
							SubmitButton(viewModel: viewModel)
	
					}
				}
				.overlay {
					ErrorOverlay(errorMessage: viewModel.errorMessage)
				}
				.overlay {
					if viewModel.isLoading {
						ProgressView()
					}
				}
		}
	}
}

// MARK: - Form Sections
struct FormContent: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Form {
			MedicalHistorySection(viewModel: viewModel)
			LifestyleHabitsSection(viewModel: viewModel)
			EnvironmentalFactorsSection(viewModel: viewModel)
			AdditionalInformationSection(viewModel: viewModel)
		}
	}
}

struct MedicalHistorySection: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Section("Medical History") {
			createTogglePicker(title: "Family history of Diabetes",
							 binding: $viewModel.familyDiabetes)
			createTogglePicker(title: "Family history of heart disease",
							 binding: $viewModel.heartDisease)
			createTogglePicker(title: "Family history of cancer",
							 binding: $viewModel.familyHistoryCancer)
			createTogglePicker(title: "Previous surgeries",
							 binding: $viewModel.previousSurgeries)
			createTogglePicker(title: "Chronic diseases",
							 binding: $viewModel.chronicDiseases)
		}
	}
}

struct LifestyleHabitsSection: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Section("Lifestyle Habits") {
			createTogglePicker(title: "Do you smoke?",
							 binding: $viewModel.smoke)
			
			AlcoholConsumptionPicker(viewModel: viewModel)
			PhysicalActivityPicker(viewModel: viewModel)
			DietQualityPicker(viewModel: viewModel)
			SleepHoursSlider(viewModel: viewModel)
		}
	}
}

struct EnvironmentalFactorsSection: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Section("Environmental Factors") {
			AirQualitySlider(viewModel: viewModel)
			PollutantExposurePicker(viewModel: viewModel)
		}
	}
}

struct AdditionalInformationSection: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Section("Additional Information") {
			StressLevelPicker(viewModel: viewModel)
			HealthcareAccessPicker(viewModel: viewModel)
		}
	}
}

// MARK: - Picker Components
struct AlcoholConsumptionPicker: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Alcohol consumption level")
			Picker("Select level", selection: $viewModel.selectedAlcoholLevel) {
				ForEach(viewModel.alcoholConsumptionLevels, id: \.self) {
					Text($0)
				}
			}
		}
	}
}

struct PhysicalActivityPicker: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Physical activity level")
			Picker("Select level", selection: $viewModel.selectedActivityLevel) {
				ForEach(viewModel.physicalActivityLevels, id: \.self) {
					Text($0)
				}
			}
		}
	}
}

struct DietQualityPicker: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Diet quality")
			Picker("Select quality", selection: $viewModel.selectedDietQuality) {
				ForEach(viewModel.dietQualityLevels, id: \.self) {
					Text($0)
				}
			}
		}
	}
}

struct PollutantExposurePicker: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Exposure to pollutants")
			Picker("Select level", selection: $viewModel.selectedPollutantExposure) {
				ForEach(viewModel.pollutantExposureLevels, id: \.self) {
					Text($0)
				}
			}
		}
	}
}

struct StressLevelPicker: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Stress Level")
			Picker("Select level", selection: $viewModel.selectedStressLevel) {
				ForEach(viewModel.stressLevels, id: \.self) {
					Text($0)
				}
			}
		}
	}
}

struct HealthcareAccessPicker: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Access to healthcare")
			Picker("Select level", selection: $viewModel.selectedHealthcareAccess) {
				ForEach(viewModel.healthcareAccessLevels, id: \.self) {
					Text($0)
				}
			}
		}
	}
}

struct SleepHoursSlider: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Average sleep hours")
				.font(.body)
			HStack {
				Slider(
					value: $viewModel.sleepHours,
					in: viewModel.sleepHoursRange,
					step: 0.5
				)
				.tint(.blue)
				
				Text("\(viewModel.sleepHours, specifier: "%.1f") Hrs")
					.font(.headline)
					.foregroundStyle(Color.blue)
					.frame(width: 70)
			}
			.padding(.vertical, 4)
			Text("Recommended: 7-9 Hours")
				.font(.caption)
				.foregroundStyle(Color.secondary)
		}
	}
}

struct AirQualitySlider: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Air quality index")
				.font(.body)
			HStack {
				Slider(
					value: $viewModel.airQualityIndex,
					in: viewModel.airQualityIndexRange,
					step: 1
				)
				.tint(.blue)
				
				Text("\(Int(viewModel.airQualityIndex)) Index")
					.font(.headline)
					.foregroundStyle(Color.blue)
					.frame(width: 70)
			}
			.padding(.vertical, 4)
			
			Text(viewModel.getAirQualityDescription())
				.font(.caption)
				.foregroundStyle(viewModel.getAirQualityColor())
		}
	}
}

// MARK: - Supporting Views
struct SubmitButton: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Button(action: {
			viewModel.submitAssessment()
		}) {
			if viewModel.isLoading {
				ProgressView()
			} else {
				Text("Submit")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundStyle(.white)
					.frame(width: 250, height: 50)
					.background(.black)
					.clipShape(.capsule)
			}
		}
		
		.disabled(viewModel.isLoading)
	}
}

struct ErrorOverlay: View {
	let errorMessage: String
	
	var body: some View {
		if !errorMessage.isEmpty {
			Text(errorMessage)
				.foregroundColor(.red)
				.padding()
		}
	}
}

// MARK: - Helper Functions
func createTogglePicker(title: String, binding: Binding<String>) -> some View {
	Picker(title, selection: binding) {
		Text("Yes").tag("yes")
		Text("No").tag("no")
	}
}

#Preview {
	HealthAssessmentScreen()
}
