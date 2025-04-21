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
                                    placeholder: "e.g., 120/80",
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
                    Button("Update") {
                        viewModel.saveChanges {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.hasChanges)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Edit Health Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                viewModel.appState = appState // Inject AppState into ViewModel
                if let healthData = appState.currentUserHealthData {
                    viewModel.loadInitialData(healthData: healthData)
                }
            }
        }
    }
}
