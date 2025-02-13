//
//  ProfileEditScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 13/02/2025.
//

import SwiftUI

struct ProfileEditScreen: View {
	@StateObject private var viewModel = SignUpViewModel()
    var body: some View {
		VStack {
			Text("Edit User data")
				.font(.title)
				.fontWeight(.bold)
			StyledTextField(title: "Name", placeholder: "Update Name", text: $viewModel.fullName)
			StyledTextField(title: "Age", placeholder: "Update Age", text: $viewModel.age)
				StyledTextField(title: "Weight", placeholder: "Update weight", text: $viewModel.age)

			
			
		}.padding(.all, 30)
		
		
    }
}

#Preview {
	ProfileEditScreen()
}
