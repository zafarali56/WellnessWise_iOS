//
//  HealthAssesmentScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import SwiftUI

struct HealthAssessmentScreen: View {
	@StateObject private var viewModel = HealthAssesmentViewModel()
	
	var body: some View {
		NavigationStack {
			Form {
				// MARK: - Medical History Section
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
				
				// MARK: - Lifestyle Habits Section
				Section("Lifestyle Habits") {
					createTogglePicker(title: "Do you smoke?",
									 binding: $viewModel.smoke)
					
					VStack(alignment: .leading) {
						Text("Alcohol consumption level")
						Picker("Select level", selection: $viewModel.selectedAlcholoLevel) {
							ForEach(viewModel.AlcholoConsumptionLevel, id: \.self) {
								Text($0)
							}
						}
					}
					
					VStack(alignment: .leading) {
						Text("Physical activity level")
						Picker("Select level", selection: $viewModel.selectedPhysicalActivityLevel) {
							ForEach(viewModel.physicalActivityLevel, id: \.self) {
								Text($0)
							}
						}
					}
					
					VStack(alignment: .leading) {
						Text("Diet quality")
						Picker("Select quality", selection: $viewModel.selectedDietQuality) {
							ForEach(viewModel.dietQualityLevel, id: \.self) {
								Text($0)
							}
						}
					}
				}
			}
			.navigationTitle("Health Assessment")
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button (action:{
						viewModel.submitAssesment()
					}){
						if viewModel.isLoading{
							ProgressView()
						}
						else {
							Text("Submit")
								.font(.subheadline)
								.fontWeight(.semibold)
								.foregroundStyle(.white)
								.frame(width:250, height: 50)
								.background(.black)
								.clipShape(.capsule)
						}
					}
					.disabled(viewModel.isLoading)
				}
			}
			// Show error message if any
			.overlay {
				if !viewModel.errorMessage.isEmpty {
					Text(viewModel.errorMessage)
						.foregroundColor(.red)
						.padding()
				}
			}
			// Show loading indicator
			.overlay {
				if viewModel.isLoading {
					ProgressView()
				}
			}
		}
	}
	
	// Helper function to create consistent Yes/No pickers
	private func createTogglePicker(title: String, binding: Binding<String>) -> some View {
		Picker(title, selection: binding) {
			Text("Yes").tag("yes")
			Text("No").tag("no")
		}
	}
}

#Preview {
	HealthAssessmentScreen()
}
