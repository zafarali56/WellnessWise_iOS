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
					createTogglePicker(
						title: "Family history of Diabetes",
						binding: $viewModel
							.familyDiabetes)
					
				}
				Section(header : Text("Life style habits"))
				{
					
						
					}

				}
			}
		}
	
	private func createTogglePicker (title: String, binding : Binding<String>) -> some View {
		Picker(title, selection: binding) {
			Text ("Yes").tag("yes")
			Text("No").tag("no")
		}
	}
	
}


#Preview {
	HealthAssesmentScreen()
}
