//
//  HealthDataScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 29/10/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HealthDataScreen: View {
    @State private var isManualInput = true
    @StateObject var viewModel: HealthDataViewModel
    @EnvironmentObject private var navigationManager: NavigationManager

    var body: some View {
        ScrollView {
            VStack {
                FormContent(isManualInput: $isManualInput, viewModel: viewModel)
            }
            .navigationTitle("Health Data")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToggleInputMethodButton(isManualInput: $isManualInput, isLoading: viewModel.isLoading)
                }
                ToolbarItem(placement: .bottomBar) {
                    BottomBarContent(isManualInput: $isManualInput, viewModel: viewModel)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden(true)
        .padding(30)
    }
}

struct ToggleInputMethodButton: View {
    @Binding var isManualInput: Bool
    let isLoading: Bool

    var body: some View {
        Button(action: {
            isManualInput.toggle()
        }) {
            HStack {
                Image(systemName: isManualInput ? "applelogo" : "keyboard")
                Text(isManualInput ? "Sync from Apple Health" : "Enter Manually")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .buttonStyle(.borderedProminent)
        .clipShape(Capsule())
        .tint(.black)
        .disabled(isLoading)
    }
}

private struct FormContent: View {
    @Binding var isManualInput: Bool
    @ObservedObject var viewModel: HealthDataViewModel

    var body: some View {
        VStack(spacing: 5) {
            if isManualInput {
                ManualInputView(viewModel: viewModel)
            } else {
                HealthKitDataView(viewModel: viewModel)
            }
            Group {
                StyledTextField(title: "Cholesterol",
                                placeholder: "e.g. 100-300",
                                text: $viewModel.cholesterol,
                                isNumber: true,
                                isValid: viewModel.isCholesterolValid)
                StyledTextField(title: "Waist Circumference",
                                placeholder: "e.g. 15-130",
                                text: $viewModel.waistCircumference,
                                isNumber: true,
                                isValid: viewModel.isWaistCircumferenceValid)
                StyledTextField(title: "Triglycerides",
                                placeholder: "e.g. 50-200",
                                text: $viewModel.triglycerides,
                                isNumber: true,
                                isValid: viewModel.isTriglyceridesValid)
            }
        }
    }
}

struct ManualInputView: View {
    @ObservedObject var viewModel: HealthDataViewModel

    var body: some View {
        VStack {
            HStack {
                StyledTextField(title: "Systolic",
                                placeholder: "120",
                                text: $viewModel.systolic,
                                isNumber: true,
                                isValid: viewModel.isBPValid)
                StyledTextField(title: "Diastolic",
                                placeholder: "80",
                                text: $viewModel.diastolic,
                                isNumber: true,
                                isValid: viewModel.isBPValid)
            }
            StyledTextField(title: "Heart Rate",
                            placeholder: "e.g. 50-150",
                            text: $viewModel.heartRate,
                            isNumber: true,
                            isValid: viewModel.isHeartRateValid)
            StyledTextField(title: "Blood Sugar",
                            placeholder: "e.g. 80-180",
                            text: $viewModel.bloodSugar,
                            isNumber: true,
                            isValid: viewModel.isBloodSugarValid)
        }
    }
}

private struct BottomBarContent: View {
    @Binding var isManualInput: Bool
    @EnvironmentObject private var navigationManager: NavigationManager
    @ObservedObject var viewModel: HealthDataViewModel

    var body: some View {
        Button(action: {
            Task {
                if isManualInput {
                    await viewModel.submitManual(using: navigationManager)
                } else {
                    await viewModel.submitHealthKit(using: navigationManager)
                }
            }
        }) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text(isManualInput ? "Submit Manually" : "Submit via HealthKit")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: 250, height: 30)
            }
        }
        .buttonStyle(.borderedProminent)
        .clipShape(Capsule())
        .tint(.black)
        .padding()
        .disabled(viewModel.isLoading || viewModel.healthKitViewModel.isLoading)
    }
}

struct HealthKitDataView: View {
    @ObservedObject var viewModel: HealthDataViewModel
    @State private var hasFetchedData = false

    var body: some View {
        VStack {
            if viewModel.healthKitViewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.healthKitViewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if let hr = viewModel.healthKitViewModel.heartRate,
                      let sys = viewModel.healthKitViewModel.systolicBP,
                      let dia = viewModel.healthKitViewModel.diastolicBP,
                      let glucose = viewModel.healthKitViewModel.bloodGlucose {
                HealthKitFieldView(fieldName: "Blood Sugar", fieldValue: "\(glucose) mg/dL")
                HealthKitFieldView(fieldName: "Heart Rate", fieldValue: "\(hr) bpm")
                HealthKitFieldView(fieldName: "Systolic", fieldValue: "\(sys) mmHg")
                HealthKitFieldView(fieldName: "Diastolic", fieldValue: "\(dia) mmHg")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.8)))
        .onAppear {
            if !hasFetchedData {
                hasFetchedData = true
                Task {
                    await viewModel.healthKitViewModel.fetchAllData()
                }
            }
        }
    }
}

struct HealthKitFieldView: View {
    let fieldName: String
    let fieldValue: String

    var body: some View {
        HStack {
            Text(fieldName)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Text(fieldValue)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - Preview

struct HealthDataScreen_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataScreen(viewModel: HealthDataViewModel(healthKitViewModel: HealthKitViewModel()))
            .environmentObject(NavigationManager())
    }
}
