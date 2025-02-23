//
//  ProfileEditScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 13/02/2025.
//

import SwiftUI

struct ProfileEditScreen: View {
	@StateObject private var viewModel = ProfileEditViewModel()
	@EnvironmentObject private var navigationManager : NavigationManager
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack(){	
			Form {
				Section {
					Text("Edit User data")
						.font(.title)
						.fontWeight(.bold)
					StyledTextField(title: "Name", placeholder: "Update Name", text: $viewModel.fullName)
					StyledTextField(title: "Age", placeholder: "Update Age", text: $viewModel.age)
					StyledTextField(title: "Weight", placeholder: "Update weight", text: $viewModel.weight)
				}
				Section {
					Button {
						viewModel.saveChanges{
							dismiss()
						}
					} label: {
						Text("Update")
							.font(.subheadline)
							.fontWeight(.medium)
							.frame(maxWidth: .infinity)
					}
				}
			}
			
			.navigationTitle("Edit profile")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar{
				ToolbarItem(placement: .navigationBarLeading){
					Button("Close"){
						dismiss()
					}
				}	
			}
			
		}
	}
}
#Preview {
	ProfileEditScreen()
}
