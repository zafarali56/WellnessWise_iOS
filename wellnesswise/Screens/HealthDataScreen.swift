//
//  HealthDataScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import SwiftUI

struct HealthDataScreen: View {
	@State var isHealthInputManual: Bool = true
	@StateObject var viewModel : HealthDataViewModel
	@EnvironmentObject private var navigationManager: NavigationManager
	var body: some View {
		ScrollView{
			VStack {
				FormContent(
					isHealthInputManual: $isHealthInputManual,
					viewModel: viewModel
				)
					.navigationTitle("Health Data")
					.toolbar{
						ToolbarItem(placement: .bottomBar){
							BottomBarContent(
								isHealthInputManual: $isHealthInputManual,
								viewModel: viewModel
							)
						}
					}
			}
			
		}
		.navigationBarBackButtonHidden()
		.padding(30)
	}
}

private struct FormContent : View {
	@Binding var isHealthInputManual : Bool
	@StateObject var viewModel : HealthDataViewModel
	@EnvironmentObject private var navigationManager : NavigationManager
	
	var body: some View {
		VStack(spacing: 5){
			
			Button(action: {
				isHealthInputManual.toggle()
			}) {
				HStack {
					Image(systemName: isHealthInputManual ? "applelogo" : "keyboard")
					Text(isHealthInputManual ? "Sync from apple health " : "Enter manually")
						.font(.headline)
						.fontWeight(.semibold)
				}
			}
			.buttonStyle(.borderedProminent)
			.clipShape(.capsule)
			.tint(.black)
			.disabled(viewModel.isLoading)

			
			
			if isHealthInputManual {
				EnterManual(viewModel: viewModel)
			} else {
				HealthKitDataView(viewModel: viewModel)
				
			}
			StyledTextField(
				title: "Cholestrol",
				placeholder: "eg. 100-300",
				text: $viewModel
					.Cholestrol,
				isNumber: true,
				isValid: viewModel.isCholestrolValid
			)
			StyledTextField(
				title: "Waist circumference",
				placeholder: "eg. 15-130",
				text: $viewModel
					.WaistCircumference
				, isNumber: true,
				isValid: viewModel.isWaistCircumferenceValid
			)
			StyledTextField(
				title: "Triglycerides",
				placeholder: "eg. 50-200",
				text: $viewModel
					.Triglycerides,
				isNumber: true
				, isValid: viewModel.isTriglycerides
			)
			
		}
	}
}

private struct EnterManual : View {

	@StateObject var viewModel : HealthDataViewModel
	var body: some View {
		VStack{
			HStack(){
				StyledTextField(
					title: "Systolic",
					placeholder:"120",
					text: $viewModel.Systolic,
					isNumber: true,
					isValid: viewModel.isBpValid
				)
				StyledTextField(
					title: "Diastolic",
					placeholder: "80",
					text: $viewModel.Diastolic,
					isNumber: true,
					isValid: viewModel.isBpValid
				)
				
			}
			StyledTextField(
				title: "Heart rate",
				placeholder: "eg. 50-150",
				text: $viewModel
					.HeartRate,
				isNumber: true,
				isValid: viewModel.isHearRateValid
			)
			
			StyledTextField(
				title: "Blood sugar",
				placeholder: "eg. 80-180",
				text: $viewModel
					.BloodSugar
				, isNumber: true,
				isValid: viewModel.isBloodSugarValid
			)
		}
	}
}

private struct BottomBarContent: View {
	@Binding var isHealthInputManual: Bool
	@EnvironmentObject private var navigationManager: NavigationManager
	@ObservedObject var viewModel: HealthDataViewModel
	var body: some View {
		VStack {
			

			Button(action: {
				if isHealthInputManual {
					viewModel.SubmitManually(using: navigationManager)
					
				} else {
					viewModel
						.SubmitByHealthKit(using: navigationManager)
						
				}
			}) {
				if viewModel.isLoading {
					ProgressView()
						.tint(.white)
				} else {
					Text(isHealthInputManual ? "Submit Manually" : "Submit via HealthKit")
						.font(.headline)
						.fontWeight(.semibold)
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity)
						.frame(width: 250, height: 30)
				}
			}
			.buttonStyle(.borderedProminent)
			.clipShape(.capsule)
			.tint(.black)
			.padding()
			.disabled(
				viewModel.isLoading || viewModel.healthKitViewModel.isLoading
			)
		}
	}
}

#Preview {
	HealthDataScreen(
		viewModel: HealthDataViewModel(
			healthKitViewModel: HealthKitViewModel()
		)
	)
}
struct HealthKitDataView: View {
	@ObservedObject var viewModel : HealthDataViewModel
	var body: some View {
		VStack {
			if viewModel.healthKitViewModel.isLoading {
				ProgressView("Fetching Health Data...")
			} else if let error = viewModel.healthKitViewModel.errorMessage {
				Text("Error: \(error)")
					.foregroundColor(.red)
			} else {
				if let heartRate = viewModel.healthKitViewModel.heartRate {
					healthKitView(
						fieldName: "Heart rate",
						fieldValue: heartRate)
				}
				if let systolic = viewModel.healthKitViewModel.systolicBP,
				   let diastolic = viewModel.healthKitViewModel.diastolicBP {
					healthKitView (
						fieldName: "Systolic",
						fieldValue: systolic)
					healthKitView (
						fieldName: "Diastiolic",
						fieldValue: diastolic
					)
				}
				if let bloodGlucose = viewModel.healthKitViewModel.bloodGlucose {
					healthKitView(
						fieldName: "Blood Sugar",
						fieldValue: bloodGlucose)
				}
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(Color.white.opacity(0.8))
				.shadow(radius: 5)
		)
		.padding(.horizontal)
		.task {
			await viewModel.healthKitViewModel.fetchAllData()
		}
	}
}


private struct healthKitView: View {
	var fieldName: String
	var fieldValue: Double
	
	var body: some View {
		HStack {
			Text(fieldName)
				.font(.body)
				.foregroundColor(.primary)
			Spacer()
			Text("\(fieldValue, specifier: "%.1f") bpm")
				.font(.body)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.trailing)
		}
		.padding(.horizontal)
		
	}
}
