import SwiftUI


struct HealthAssessmentScreen: View {
	@EnvironmentObject private var navigationManager: NavigationManager
	@StateObject private var viewModel: HealthAssessmentViewModel
	init(isEditing: Bool = false) {
		_viewModel = StateObject(
			wrappedValue: HealthAssessmentViewModel(isEditing: isEditing)
		)
	}
	var body: some View {
		VStack{
			FormContent(viewModel: viewModel)
				.navigationTitle("Health Assessment")
				.toolbar {
					ToolbarItem(placement: .bottomBar) {
						BottomBarContent(viewModel: viewModel)
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
		.navigationBarBackButtonHidden(!viewModel.isEditing)//Show back button only when editing
	}
}

private struct FormContent: View {
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
private struct BottomBarContent: View {
	@EnvironmentObject private var navigationManager : NavigationManager
	@ObservedObject var viewModel: HealthAssessmentViewModel
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		VStack(spacing: 8) {
			Button(
				action: { viewModel.submitAssessment(
					using: navigationManager,
					dismiss: dismiss
				)
				}) {
				if viewModel.isLoading {
					ProgressView()
					.tint(.white)
				} else {
					Text("Submit")
						.font(.headline)
						.fontWeight(.semibold)
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity)
						.frame(width: 250,height: 30)
				}
			}
			.buttonStyle(.borderedProminent)
			.clipShape(.capsule)
			.tint(.black)
			.disabled(viewModel.isLoading)
		}
		
	}
}
private struct MedicalHistorySection: View {
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

private struct LifestyleHabitsSection: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Section("Lifestyle Habits") {
			createTogglePicker(title: "Do you smoke?",
							   binding: $viewModel.smoke)
			
			CustomPicker(
				headerText: "Alcohol consumption level:",
				pickerText: "Select level",
				options: viewModel.alcoholConsumptionLevels,
				selected: $viewModel.selectedAlcoholLevel)
			
			CustomPicker(
				headerText: "Physical activity level:",
				pickerText: "Select level",
				options: viewModel.physicalActivityLevels,
				selected: $viewModel.selectedActivityLevel
			)
			
			
			CustomPicker(
				headerText: "Diet quality levels:",
				pickerText: "Select quality",
				options: viewModel.dietQualityLevels,
				selected: $viewModel.selectedDietQuality
			)
			
			SleepHoursSlider(viewModel: viewModel)
		}
	}
}

private struct EnvironmentalFactorsSection: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Section("Environmental Factors") {
			AirQualitySlider(viewModel: viewModel)
			CustomPicker(
				headerText: "Exposure to pollutants",
				pickerText: "Select level",
				options: viewModel.pollutantExposureLevels,
				selected: $viewModel.selectedPollutantExposure
			)
		}
	}
}

struct AdditionalInformationSection: View {
	@ObservedObject var viewModel: HealthAssessmentViewModel
	
	var body: some View {
		Section("Additional Information") {
			CustomPicker(
				headerText: "Stress levels",
				pickerText: "Select level",
				options: viewModel.stressLevels,
				selected: $viewModel.selectedStressLevel
			)
			CustomPicker(
				headerText: "Acccess to healthcare",
				pickerText: "Select Quality",
				options: viewModel.healthcareAccessLevels,
				selected: $viewModel.selectedHealthcareAccess
			)
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

func createTogglePicker(title: String, binding: Binding<String>) -> some View {
	Picker(title, selection: binding) {
		Text("Yes").tag("yes")
		Text("No").tag("no")
	}
}

#Preview {
	HealthAssessmentScreen()
}
