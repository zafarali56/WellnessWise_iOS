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
	@StateObject var healthKitViewModel : HealthKitViewModel
	var body: some View {
		ScrollView{
			VStack {
				FormContent(
					isHealthInputManual: $isHealthInputManual,
					viewModel: viewModel, healthKitViewModel: healthKitViewModel
				)
					.navigationTitle("Health Data")
					.toolbar{
						ToolbarItem(placement: .bottomBar){
							BottomBarContent(
								isHealthInputManual: $isHealthInputManual,
								viewModel: viewModel, healthKitViewModel: healthKitViewModel
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
	@ObservedObject var healthKitViewModel: HealthKitViewModel
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
				HealthKitDataView(healthKitViewModel: healthKitViewModel)
				
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
	@ObservedObject var healthKitViewModel : HealthKitViewModel
	var body: some View {
		VStack {
			

			Button(action: {
				if isHealthInputManual {
					viewModel.SubmitManually(using: navigationManager)
				} else {
					healthKitViewModel
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
			.disabled(viewModel.isLoading || healthKitViewModel.isLoading)
		}
	}
}

#Preview {
	HealthDataScreen(
		viewModel: HealthDataViewModel(), healthKitViewModel: HealthKitViewModel()
	)
}
struct HealthKitDataView: View {
	@ObservedObject var healthKitViewModel = HealthKitViewModel()
	
	var body: some View {
		VStack {
			if healthKitViewModel.isLoading {
				ProgressView("Fetching Health Data...")
			} else if let error = healthKitViewModel.errorMessage {
				Text("Error: \(error)")
					.foregroundColor(.red)
			} else {
				if let heartRate = healthKitViewModel.heartRate {
					Text("Heart Rate: \(heartRate, specifier: "%.1f") bpm")
				}
				if let systolic = healthKitViewModel.systolicBP,
				   let diastolic = healthKitViewModel.diastolicBP {
					Text("Blood Pressure: \(systolic, specifier: "%.0f") / \(diastolic, specifier: "%.0f") mmHg")
				}
				if let bloodGlucose = healthKitViewModel.bloodGlucose {
					Text("Blood Glucose: \(bloodGlucose, specifier: "%.1f") mg/dL")
				}
			}
		}
		.padding()
		.task {
			await healthKitViewModel.fetchAllData()
		}
	}
}


