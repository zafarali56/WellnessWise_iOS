import Foundation
import FirebaseAuth
import FirebaseFirestore

class HealthDataEditViewModel: ObservableObject {
    @Published var bloodPressure: String = ""
    @Published var bloodSugar: String = ""
    @Published var cholesterol: String = ""
    @Published var waistCircumference: String = ""
    @Published var heartRate: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    private var initialData: HealthData?
    weak var appState: AppStateManager?
    
    var hasChanges: Bool {
        if let initial = initialData {
            return bloodPressure != "\(initial.bloodPressure)" ||
            bloodSugar != "\(initial.bloodSugar)" ||
            cholesterol != "\(initial.cholesterol)" ||
            waistCircumference != "\(initial.waistCircumference)" ||
            heartRate != "\(initial.heartRate)"
        } else {
            return !bloodPressure.isEmpty ||
            !bloodSugar.isEmpty ||
            !cholesterol.isEmpty ||
            !waistCircumference.isEmpty ||
            !heartRate.isEmpty
        }
    }
    
    func loadInitialData(healthData: HealthData) {
        self.initialData = healthData
        self.bloodPressure = healthData.bloodPressure
        self.bloodSugar = healthData.bloodSugar
        self.cholesterol = healthData.cholesterol
        self.waistCircumference = healthData.waistCircumference
        self.heartRate = healthData.heartRate
    }
    
    func saveChanges(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user available."
            return
        }
        
        // Validate Blood Pressure format
        let bpComponents = bloodPressure.components(separatedBy: "/")
        guard bpComponents.count == 2 else {
            errorMessage = "Blood pressure must be in 'systolic/diastolic' format."
            return
        }
        
        let systolicStr = bpComponents[0].trimmingCharacters(in: .whitespaces)
        let diastolicStr = bpComponents[1].trimmingCharacters(in: .whitespaces)
        guard let systolic = Int(systolicStr), let diastolic = Int(diastolicStr) else {
            errorMessage = "Systolic and diastolic must be valid numbers."
            return
        }
        
        // Validate other numeric fields
        guard let bloodSugarVal = Int(bloodSugar) else {
            errorMessage = "Blood sugar must be a number."
            return
        }
        guard let cholesterolVal = Int(cholesterol) else {
            errorMessage = "Cholesterol must be a number."
            return
        }
        guard let waistCircumferenceVal = Int(waistCircumference) else {
            errorMessage = "Waist circumference must be a number."
            return
        }
        guard let heartRateVal = Int(heartRate) else {
            errorMessage = "Heart rate must be a number."
            return
        }
        
        isLoading = true
        
        // Prepare health data dictionary with correct types
        let healthData: [String: Any] = [
            "systolic": systolic,
            "diastolic": diastolic,
            "bloodSugar": bloodSugarVal,
            "cholesterol": cholesterolVal,
            "waistCircumference": waistCircumferenceVal,
            "heartRate": heartRateVal
        ]
        
        let fullData: [String: Any] = [
            "healthData": healthData,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Save new health data document
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("healthData")
            .addDocument(data: fullData) { [weak self] error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Error saving data: \(error.localizedDescription)"
                } else {
                    // Refresh health data in AppState
                    Task {
                        await self.appState?.fetchHealthData(userId: userId)
                    }
                    completion()
                }
            }
    }
}
