import SwiftUI

struct ProfileEditScreen: View {
    @StateObject private var viewModel = ProfileEditViewModel()
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var appState: AppStateManager // Provides currentUserData
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header:
                            Text("Edit User Data")
                                .font(.title2)
                                .bold()
                ) {
                    StyledTextField(title: "Name",
                                    placeholder: "Update Name",
                                    text: $viewModel.fullName)
                    StyledTextField(title: "Age",
                                    placeholder: "Update Age",
                                    text: $viewModel.age,
                                    isNumber: true)
                    StyledTextField(title: "Weight",
                                    placeholder: "Update Weight",
                                    text: $viewModel.weight,
                                    isNumber: true)
                }
                
                Section {
                    Button(action: {
                        viewModel.saveChanges {
                            dismiss()
                        }
                    }) {
                        Text("Update")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!viewModel.hasChanges)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                // Load the existing user data (if available) into the view model
                if let userData = appState.currentUserData {
                    viewModel.loadInitialData(userData: userData)
                }
            }
        }
    }
}

#Preview {
    ProfileEditScreen()
}
