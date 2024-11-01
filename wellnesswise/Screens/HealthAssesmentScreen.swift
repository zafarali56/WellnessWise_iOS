//
//  HealthAssesmentScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import SwiftUI

struct HealthAssesmentScreen: View {
	@StateObject private var viewModel = HealthAssesmentViewModel()
    var body: some View {
		VStack{
			Text("Health Assessment").font(.title2)
			Form {
				Section(header: Text("Medical history") )
				{
					Picker(selection: $viewModel.familyDiabetes, label: Text("Family history of Diabetes"))
					{
						Text("Yes").tag ("yes")
						Text("No").tag ("no")
					}
					
					Picker(
						selection: $viewModel.heartDisease, label: Text("Family history of heart disease"))
					{
						Text ("Yes").tag("yes")
						Text("No").tag ("no")
					}
					
					Picker (
						selection : $viewModel.familyHistoryCancer , label: Text("Family history of cancer")) {
							Text("Yes").tag("yes")
							Text("No").tag("no")
						}
					
					Picker (selection: $viewModel.previousSurgeries, label: Text ("Preview surgeries"))
					{
						Text("Yes").tag ("yes")
						Text("No").tag ("no")
					}
					
					Picker (selection: $viewModel.choricDiseases, label: Text("Chronic diseases"))
					{
						Text("Yes").tag("yes")
						Text("No").tag("no")
					}
				}
				
			}
		}
    }
}

#Preview {
    HealthAssesmentScreen()
}
