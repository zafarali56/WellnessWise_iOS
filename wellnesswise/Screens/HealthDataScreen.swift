//
//  HealthDataScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import SwiftUI

struct HealthDataScreen: View {
	@StateObject var viewModel : HealthDataViewModel
	var body: some View {
		ScrollView{
			VStack {
				FormContent(viewModel: viewModel)
			}
			
		}
		.navigationTitle("Health Data")
		.navigationBarTitleDisplayMode(.large)
		.navigationBarBackButtonHidden()
		.padding(40)
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
				placeholder: "Bpm",
				text: $viewModel
					.HeartRate,
				isNumber: true
			)
			
			StyledTextField(
				title: "Cholestrol",
				placeholder: "200",
				text: $viewModel
					.Cholestrol,
				isNumber: true
			)
			
			StyledTextField(
				title: "Waist circumference",
				placeholder: "eg. 47",
				text: $viewModel
					.WaistCircumference
				, isNumber: true
			)
			
			StyledTextField(
				title: "Triglycerides",
				placeholder: "Enter the value",
				text: $viewModel
					.Triglycerides,
				isNumber: true)
			
		}
	}
}

#Preview {
	HealthDataScreen(viewModel: HealthDataViewModel())
}
