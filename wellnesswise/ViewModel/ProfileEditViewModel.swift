//
//  ProfileEditViewModel.swift
//  wellnesswise
//
//  Created by Zafar Ali on 23/02/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUICore
class ProfileEditViewModel: ObservableObject {
	@Published var fullName : String = ""
	@Published var weight : String = ""
	@Published var age : String = ""
	private var initialData: User?
	//checking the changes in the User struct for comparision user struct is in the #appstatemanager and being update evertime there is a change or initilization.
	var hasChanges : Bool {
		guard let initial = initialData else {return false}
		return fullName != initial.fullName || age != initial.age || weight != initial.weight
	}
	
	
	func loadInitialData (userData : User){
		self.initialData = userData
		self.fullName = fullName
		self.age = age
		self.weight = weight
	}
	
	func saveChanges (completion: @escaping () -> Void){
		guard let userId = Auth.auth().currentUser?.uid else {return }
		Firestore.firestore().collection("users").document(userId).updateData([
			"fullName" : fullName, 
			"age": age, 
			"weight" : weight])
		{error in 
			if let error = error {
				print("#Error updating user documents: \(error)")
			}else {
				completion()
			}
		}
	}
	
	
}


