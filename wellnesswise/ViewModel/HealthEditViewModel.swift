import Foundation
import FirebaseAuth
import FirebaseFirestore

class HealthDataEditViewModel: ObservableObject {
    @Published var bloodPressure: String = ""
    @Published var bloodSugar: String = ""
    @Published var cholesterol: String = ""
    @Published var waistCircumference: String = ""
    @Published var heartRate: String = ""
    
    private var initialData: HealthData?
    
    var hasChanges: Bool {
        if let initial = initialData {
            return bloodPressure != "\(initial.bloodPressure)" ||
            bloodSugar != "\(initial.bloodSugar)" ||
            cholesterol != "\(initial.cholesterol)" ||
            waistCircumference != "\(initial.waistCircumference)" ||
            heartRate != "\(initial.heartRate)"
        } else {
            // No initial data—if any field is non-empty, consider it as "changed"
            return !bloodPressure.isEmpty ||
            !bloodSugar.isEmpty ||
            !cholesterol.isEmpty ||
            !waistCircumference.isEmpty ||
            !heartRate.isEmpty
        }
    }
    
    func loadInitialData(healthData: HealthData) {
        self.initialData = healthData
        self.bloodPressure = "\(healthData.bloodPressure)"
        self.bloodSugar = "\(healthData.bloodSugar)"
        self.cholesterol = "\(healthData.cholesterol)"
        self.waistCircumference = "\(healthData.waistCircumference)"
        self.heartRate = "\(healthData.heartRate)"
    }
    
    func saveChanges(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user available.")
            return
        }
        
        let updateFields: [String: Any]
        if let initial = initialData {
            // Use new value if provided; otherwise, fallback to original.
            let updatedBloodPressure = bloodPressure.isEmpty ? "\(initial.bloodPressure)" : bloodPressure
            let updatedBloodSugar = bloodSugar.isEmpty ? "\(initial.bloodSugar)" : bloodSugar
            let updatedCholestrol = cholesterol.isEmpty ? "\(initial.cholesterol)" : cholesterol
            let updatedWaistCircumference = waistCircumference.isEmpty ? "\(initial.waistCircumference)" : waistCircumference
            let updatedHeartRate = heartRate.isEmpty ? "\(initial.heartRate)" : heartRate
            
            updateFields = [
                "bloodPressure": updatedBloodPressure,
                "bloodSugar": updatedBloodSugar,
                "cholestrol": updatedCholestrol,
                "waistCircumference": updatedWaistCircumference,
                "heartRate": updatedHeartRate
            ]
        } else {
            // No initial data: just use current field values.
            updateFields = [
                "bloodPressure": bloodPressure,
                "bloodSugar": bloodSugar,
                "cholesterol": cholesterol,
                "waistCircumference": waistCircumference,
                "heartRate": heartRate
            ]
        }
        
        print("Updating health data for user \(userId) with fields: \(updateFields)")
        
        // Use setData with merge:true so that it creates the document if needed.
        Firestore.firestore().collection("users")
            .document(userId)
            .collection("healthData")
            .document("latest")
            .setData(updateFields, merge: true) { error in
                if let error = error {
                    print("Error updating health data: \(error)")
                } else {
                    print("Health data updated successfully.")
                    completion()
                }
            }
    }
}
