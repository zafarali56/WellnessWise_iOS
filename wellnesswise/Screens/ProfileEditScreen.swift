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
	var onCancel: () -> Void
	var body: some View {
		NavigationView(){	
		
		Text("Edit User data")
				.font(.title)
				.fontWeight(.bold)
			StyledTextField(title: "Name", placeholder: "Update Name", text: $viewModel.fullName)
			StyledTextField(title: "Age", placeholder: "Update Age", text: $viewModel.age)
			StyledTextField(title: "Weight", placeholder: "Update weight", text: $viewModel.weight)
			Button {
				viewModel.userProfileUpdation(using: navigationManager)
			} label: {
				Text("Update")
					.font(.subheadline)
					.fontWeight(.medium)
					.padding(.bottom, 10)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbar{
			ToolbarItem(placement: .navigationBarLeading){
				Button("Close"){
					onCancel()
				}
			}	
		}
    }
}

#Preview {
	ProfileEditScreen(onCancel: {})
}
