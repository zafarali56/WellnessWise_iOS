import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUICore

class ProfileEditViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var weight: String = ""
    @Published var age: String = ""
    
    private var initialData: User?
    
    // Indicates whether any field has changed compared to the original data.
    var hasChanges: Bool {
        guard let initial = initialData else { return false }
        return fullName != initial.fullName ||
               age != "\(initial.age)" ||
               weight != "\(initial.weight)"
    }
    
    /// Loads the existing user data into the view model.
    /// This method makes sure to display the current values so the user
    /// can edit them or keep the existing ones.
    func loadInitialData(userData: User) {
        self.initialData = userData
        // Assign actual values from the passed userData.
        self.fullName = userData.fullName
        self.age = "\(userData.age)"       // Convert to String if needed.
        self.weight = "\(userData.weight)"   // Convert to String if needed.
    }
    
    /// Saves the changes to Firestore.
    /// If a field is left empty, the existing value is used so that it doesn't reset.
    func saveChanges(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
              let initial = initialData else { return }
        
        // Use the current value if not empty; otherwise, fallback to the original value.
        let updatedFullName = fullName.isEmpty ? initial.fullName : fullName
        let updatedAge = age.isEmpty ? "\(initial.age)" : age
        let updatedWeight = weight.isEmpty ? "\(initial.weight)" : weight
        
        let updateFields: [String: Any] = [
            "fullName": updatedFullName,
            "age": updatedAge,
            "weight": updatedWeight
        ]
        
        Firestore.firestore().collection("users").document(userId).updateData(updateFields) { error in
            if let error = error {
                print("#Error updating user document: \(error)")
            } else {
                completion()
            }
        }
    }
}
