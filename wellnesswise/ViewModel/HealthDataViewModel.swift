import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class HealthDataViewModel: ObservableObject {
    @Published var healthKitViewModel: HealthKitViewModel
    @Published var systolic = ""
    @Published var diastolic = ""
    @Published var bloodSugar = ""
    @Published var heartRate = ""
    @Published var cholesterol = ""
    @Published var waistCircumference = ""
    @Published var triglycerides = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading = false

    init(healthKitViewModel: HealthKitViewModel) {
        self.healthKitViewModel = healthKitViewModel
    }

    // MARK: - Validation

    var isBPValid: Bool {
        !systolic.isEmpty && !diastolic.isEmpty
    }
    var isBloodSugarValid: Bool {
        !bloodSugar.isEmpty
    }
    var isHeartRateValid: Bool {
        !heartRate.isEmpty
    }
    var isCholesterolValid: Bool {
        !cholesterol.isEmpty
    }
    var isWaistCircumferenceValid: Bool {
        !waistCircumference.isEmpty
    }
    var isTriglyceridesValid: Bool {
        !triglycerides.isEmpty
    }
    var isValid: Bool {
        isBPValid && isBloodSugarValid && isHeartRateValid && isCholesterolValid && isWaistCircumferenceValid && isTriglyceridesValid
    }

    // MARK: - Submission Methods

    func submitManual(using navigationManager: NavigationManager) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated"
            return
        }
        guard isValid else {
            errorMessage = "Please fill in all the fields"
            return
        }
        errorMessage = nil
        isLoading = true

        let healthData: [String: Any] = [
            "healthData": [
                "systolic": systolic,
                "diastolic": diastolic,
                "heartRate": heartRate,
                "cholesterol": cholesterol,
                "waistCircumference": waistCircumference,
                "bloodSugar": bloodSugar
            ],
            "timestamp": FieldValue.serverTimestamp()
        ]
        do {
            try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("healthData")
                .addDocument(data: healthData)
            isLoading = false
            navigationManager.switchToMain()
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func submitHealthKit(using navigationManager: NavigationManager) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            healthKitViewModel.errorMessage = "User not authenticated"
            return
        }
        print(userId)
        
        
        healthKitViewModel.errorMessage = nil
        healthKitViewModel.isLoading = true

        guard let systolicValue = healthKitViewModel.systolicBP,
              let diastolicValue = healthKitViewModel.diastolicBP,
              let heartRateValue = healthKitViewModel.heartRate,
              let bloodGlucoseValue = healthKitViewModel.bloodGlucose else {
            healthKitViewModel.errorMessage = "Values are either null or missing"
            healthKitViewModel.isLoading = false
            return
        }

        let healthData: [String: Any] = [
            "healthData": [
                "systolic": systolicValue,
                "diastolic": diastolicValue,
                "heartRate": heartRateValue,
                "cholesterol": cholesterol,
                "waistCircumference": waistCircumference,
                "bloodSugar": bloodGlucoseValue
            ],
            "timestamp": FieldValue.serverTimestamp()
        ]
        do {
            try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("healthData")
                .addDocument(data: healthData)
            healthKitViewModel.isLoading = false
            navigationManager.switchToMain()
        } catch {
            healthKitViewModel.isLoading = false
            healthKitViewModel.errorMessage = error.localizedDescription
        }
    }
}
