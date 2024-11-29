//
//  HealthDataScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import SwiftUI

struct HealthDataScreen: View {
	@StateObject var viewModel : HealthDataViewModel
	@EnvironmentObject private var navigationManager: NavigationManager
	
	var body: some View {
		ScrollView{
			VStack {
				FormContent(viewModel: viewModel)
					.navigationTitle("Health Data")
					.toolbar{
						ToolbarItem(placement: .bottomBar){
							BottomBarContent(viewModel: viewModel)
						}
					}
			}
		}
		.navigationBarBackButtonHidden()
		.padding(30)
	}
}

private struct FormContent : View {
	@StateObject var viewModel : HealthDataViewModel
	var body: some View {
		VStack(spacing: 5){
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
				title: "Cholestrol",
				placeholder: "eg. 100-300",
				text: $viewModel
					.Cholestrol,
				isNumber: true,
				isValid: viewModel.isCholestrolValid
			)
			StyledTextField(
				title: "Blood sugar",
				placeholder: "eg. 80-180",
				text: $viewModel
					.BloodSugar
				, isNumber: true,
				isValid: viewModel.isBloodSugarValid
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

private struct BottomBarContent: View {
	@EnvironmentObject private var navigationManager : NavigationManager
	@ObservedObject var viewModel : HealthDataViewModel
	var body: some View {
		VStack{
			Button(action: {viewModel.Submit(using: navigationManager)}){
				if viewModel.isLoading {
					ProgressView()
						.tint(.white)
				}
				else {
					Text("Submit")
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
			.disabled(viewModel.isLoading || !viewModel.validation)
			.padding()
		}
	}
}
#Preview {
	HealthDataScreen(viewModel: HealthDataViewModel())
}
