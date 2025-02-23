//
//  ProfileEditScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 13/02/2025.
//

import SwiftUI

struct ProfileEditScreen: View {
	@StateObject private var viewModel = SignUpViewModel()
	@EnvironmentObject private var navigationManager : NavigationManager
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack(){	
			Form {
				Section("Personal information"){
					Text("Edit User data")
						.font(.title)
						.fontWeight(.bold)
					StyledTextField(title: "Name", placeholder: "Update Name", text: $viewModel.fullName)
					StyledTextField(title: "Age", placeholder: "Update Age", text: $viewModel.age)
					StyledTextField(title: "Weight", placeholder: "Update weight", text: $viewModel.weight)
					
					Section{
						Button {
							viewModel.userProfileUpdation(using: navigationManager)
							dismiss()
								
						} label: {
							Text("Update")
								.font(.subheadline)
								.fontWeight(.medium)
								.padding(.bottom, 10)
						}
					}
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

#Preview {
	ProfileEditScreen()
}
