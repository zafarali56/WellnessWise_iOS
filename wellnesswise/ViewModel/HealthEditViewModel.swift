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
    @Published var isLoading: Bool = false

    private var initialData: HealthData?
    private var healthDataDocumentID: String? // Store existing document ID

    var hasChanges: Bool {
        guard let initial = initialData else {
            return !bloodPressure.isEmpty ||
                   !bloodSugar.isEmpty ||
                   !cholesterol.isEmpty ||
                   !waistCircumference.isEmpty ||
                   !heartRate.isEmpty
        }

        return bloodPressure != "\(initial.bloodPressure)" ||
               bloodSugar != "\(initial.bloodSugar)" ||
               cholesterol != "\(initial.cholesterol)" ||
               waistCircumference != "\(initial.waistCircumference)" ||
               heartRate != "\(initial.heartRate)"
    }

    /// **Load existing health data and store the document ID**
    func loadInitialData(healthData: HealthData, documentID: String? = nil) {
        self.initialData = healthData
        self.healthDataDocumentID = documentID

        self.bloodPressure = "\(healthData.bloodPressure)"
        self.bloodSugar = "\(healthData.bloodSugar)"
        self.cholesterol = "\(healthData.cholesterol)"
        self.waistCircumference = "\(healthData.waistCircumference)"
        self.heartRate = "\(healthData.heartRate)"
    }

    /// **Save or update existing document**
    func saveChanges(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user available."
            return
        }

        guard hasChanges else {
            errorMessage = "No changes detected, skipping update."
            return
        }
        
        isLoading = true
        errorMessage = nil

        let updateFields: [String: Any] = [
            "bloodPressure": bloodPressure,
            "bloodSugar": bloodSugar,
            "cholesterol": cholesterol,
            "waistCircumference": waistCircumference,
            "heartRate": heartRate,
            "updatedAt": FieldValue.serverTimestamp() // Keep track of updates
        ]

        let healthDataRef = Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("healthData")

        if let existingDocID = healthDataDocumentID {
            // ✅ **Update the existing document**
            healthDataRef.document(existingDocID)
                .setData(updateFields, merge: true) { [weak self] error in
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = "Error updating health data: \(error.localizedDescription)"
                    } else {
                        print("Health data updated successfully.")
                        completion()
                    }
                }
        } else {
            // ✅ **No existing document? Create a new one and store the ID**
            healthDataRef.addDocument(data: updateFields) { [weak self] documentRef, error in
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Error creating health data: \(error.localizedDescription)"
                } else if let newDocID = documentRef?.documentID {
                    self?.healthDataDocumentID = newDocID
                    print("New health data created with ID: \(newDocID)")
                    completion()
                }
            }
        }
    }
}
