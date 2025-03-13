import SwiftUI

struct HealthEditScreen: View {
    @StateObject private var viewModel = HealthDataEditViewModel()
    @EnvironmentObject private var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Health Data")
                    .font(.title2)
                    .bold()
                ) {
                    StyledTextField(title: "Blood Pressure",
                                    placeholder: "Update Blood Pressure",
                                    text: $viewModel.bloodPressure)
                    StyledTextField(title: "Blood Sugar",
                                    placeholder: "Update Blood Sugar",
                                    text: $viewModel.bloodSugar,
                                    isNumber: true)
                    StyledTextField(title: "Cholesterol",
                                    placeholder: "Update Cholesterol",
                                    text: $viewModel.cholesterol,
                                    isNumber: true)
                    StyledTextField(title: "Waist Circumference",
                                    placeholder: "Update Waist Circumference",
                                    text: $viewModel.waistCircumference,
                                    isNumber: true)
                    StyledTextField(title: "Heart Rate",
                                    placeholder: "Update Heart Rate",
                                    text: $viewModel.heartRate,
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
            .navigationTitle("Edit Health Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                if let healthData = appState.currentUserHealthData {
                    // Original function that doesn't require documentID
                    viewModel.loadInitialData(healthData: healthData)
                }
            }
        }
    }
}
