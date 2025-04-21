import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct User: Codable, Identifiable {
	let id: String
	let fullName: String
	let email: String
	let age: String
	let weight: String
	let height: String
	let gender: String
}
struct HealthData: Codable, Identifiable {
    let id: String
    let bloodSugar: String
    let cholesterol: String
    let bloodPressure: String
    let heartRate: String
    let waistCircumference: String
}

struct HealthAssessment : Codable, Identifiable {
	let id : String
	let chronicDiseases : String
	let familyDiabetes : String
	let familyHistoryCancer : String
	let heartDisease : String
	let previousSurgeries : String
	var alcoholLevel : String
	var dietQuality : String
	var physicalActivityLevel : String
	var sleepHours : Int8
	var smoke: String
	var airQualityIndex : Int16
	var pollutantExposure : String
	var healthCareAcces : String
	var stresslevel : String
}

extension HealthData {
	var isEmpty : Bool {
		return bloodSugar.isEmpty && cholesterol.isEmpty && bloodSugar.isEmpty && heartRate.isEmpty && waistCircumference.isEmpty
	}
}
@MainActor
class AppStateManager: ObservableObject {
	@Published var isAuthenticated = false
	@Published var isLoading = true
	@Published var currentUserData: User?
	@Published var currentUserHealthData: HealthData?
	@Published var currentHealthAssesmentData : HealthAssessment?
	static let shared = AppStateManager()
	private let authStateKey = "com.wellnesswise.authState"
	private let userIdKey = "com.wellnesswise.userId"
	private init() {
		setupInitialState()
	}
	
	//check for empty userHealthData
	func isUserDataEmpty ()-> Bool{
		return ((currentUserHealthData?.isEmpty) != nil)
	}
	private func setupInitialState() {
		isAuthenticated = UserDefaults.standard.bool(forKey: authStateKey)
		
		if let currentUser = Auth.auth().currentUser {
			isAuthenticated = true
			UserDefaults.standard.set(true, forKey: authStateKey)
			UserDefaults.standard.set(currentUser.uid, forKey: userIdKey)
			Task {
				await fetchUserData(userId: currentUser.uid)
				isLoading = false
			}
		} else {
			if isAuthenticated {
				Task {
					await restoreSession()
				}
			} else {
				isLoading = false
			}
		}
		setupAuthListener()
	}
	private func setupAuthListener() {
		Auth.auth().addStateDidChangeListener { [weak self] _, user in
			Task { @MainActor in
				guard let self = self else { return }
				let isAuth = user != nil
				self.isAuthenticated = isAuth
				UserDefaults.standard.set(isAuth, forKey: self.authStateKey)
				if let user = user {
					UserDefaults.standard.set(user.uid, forKey: self.userIdKey)
					await self.fetchUserData(userId: user.uid)
				} else {
					self.currentUserData = nil
					UserDefaults.standard.removeObject(forKey: self.userIdKey)
				}
				self.isLoading = false
			}
		}
	}
	private func restoreSession() async {
		if let userId = UserDefaults.standard.string(forKey: userIdKey),
		   Auth.auth().currentUser != nil {
			await fetchUserData(userId: userId)
		} else {
			isAuthenticated = false
			UserDefaults.standard.set(false, forKey: authStateKey)
			UserDefaults.standard.removeObject(forKey: userIdKey)
		}
		isLoading = false
	}
	func fetchUserData(userId: String) async {
		do {
			let document = try await Firestore.firestore()
				.collection("users")
				.document(userId)
				.getDocument()
			
			guard let data = document.data() else {
				print("No user data found")
				return
			}
			self.currentUserData = User(
				id: userId,
				fullName: data["fullName"] as? String ?? "",
				email: data["email"] as? String ?? "",
				age: data["age"] as? String ?? "",
				weight: data["weight"] as? String ?? "",
				height: data["height"] as? String ?? "",
				gender: data["gender"] as? String ?? ""
			)
		} catch {
			print("Error fetching user data: \(error.localizedDescription)")
		}
	}
    func fetchHealthData(userId: String) async {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("healthData")
                .order(by: "timestamp", descending: true)
                .limit(to: 1)
                .getDocuments()
            
            var fetchedHealthData = [HealthData]()
            
            for document in snapshot.documents {
                let docData = document.data()
                if let nestedHealthData = docData["healthData"] as? [String: Any] {
                    // Parse numeric values from Firestore
                    let systolic = nestedHealthData["systolic"] as? Int ?? 0
                    let diastolic = nestedHealthData["diastolic"] as? Int ?? 0
                    let bloodSugar = nestedHealthData["bloodSugar"] as? Int ?? 0
                    let cholesterol = nestedHealthData["cholesterol"] as? Int ?? 0
                    let heartRate = nestedHealthData["heartRate"] as? Int ?? 0
                    let waistCircumference = nestedHealthData["waistCircumference"] as? Int ?? 0
                   
                    print("Debug: Cholestrol : ",cholesterol,"Debug: Waist circumference",waistCircumference)
        
                    // Construct blood pressure string
                    let bloodPressure = "\(systolic)/\(diastolic)"
                    
                    let healthRecord = HealthData(
                        id: document.documentID,
                        bloodSugar: "\(bloodSugar)",
                        cholesterol: "\(cholesterol)",
                        bloodPressure: bloodPressure,
                        heartRate: "\(heartRate)",
                        waistCircumference: "\(waistCircumference)"
                    )
                    fetchedHealthData.append(healthRecord)
                }
            }
            
            self.currentUserHealthData = fetchedHealthData.first
        } catch {
            print("Error fetching health data: \(error.localizedDescription)")
        }
    }
	func fetchHealthAssesment(userId: String) async {
		do {
			let snapShot = try await Firestore.firestore()
				.collection("users")
				.document(userId)
				.collection("assessments")
				.getDocuments()
			print("Assessment Snapshot fetched: \(snapShot.documents.count) documents")
			print("Assessment Snapshot Documents Count: \(snapShot.documents.count)")
			guard !snapShot.documents.isEmpty else {
				print("No assessment data found for userId: \(userId)")
				return
			}
			var fetchedAssessmentData = [HealthAssessment]()
			for document in snapShot.documents {
				let docData = document.data()
				let medicalHistory = docData["medicalHistory"] as? [String: Any] ?? [:]
				let chronicDiseases = medicalHistory["chronicDiseases"] as? String ?? "N/A"
				let familyDiabetes = medicalHistory["familyDiabetes"] as? String ?? "N/A"
				let familyHistoryCancer = medicalHistory["familyHistoryCancer"] as? String ?? "N/A"
				let heartDisease = medicalHistory["heartDisease"] as? String ?? "N/A"
				let previousSurgeries = medicalHistory["previousSurgeries"] as? String ?? "N/A"
				
				let lifestyleHabits = docData["lifestyleHabits"] as? [String: Any] ?? [:]
				let alcoholLevel = lifestyleHabits["alcoholLevel"] as? String ?? "N/A"
				let dietQuality = lifestyleHabits["dietQuality"] as? String ?? "N/A"
				let physicalActivityLevel = lifestyleHabits["physicalActivityLevel"] as? String ?? "N/A"
				let sleepHours = lifestyleHabits["sleepHours"] as? Int ?? 0
				let smoke = lifestyleHabits["smoke"] as? String ?? "N/A"
				
				let environmentalFactors = docData["environmentalFactors"] as? [String: Any] ?? [:]
				let airQualityIndex = environmentalFactors["airQualityIndex"] as? Int ?? 0
				let pollutantExposure = environmentalFactors["pollutantExposure"] as? String ?? "N/A"
				
				let additionalInformation = docData["additionalInformation"] as? [String: Any] ?? [:]
				let healthCareAccess = additionalInformation["healthcareAccess"] as? String ?? "N/A"
				let stressLevel = additionalInformation["stressLevel"] as? String ?? "N/A"
				let assessmentItem = HealthAssessment(
					id: document.documentID,
					chronicDiseases: chronicDiseases,
					familyDiabetes: familyDiabetes,
					familyHistoryCancer: familyHistoryCancer,
					heartDisease: heartDisease,
					previousSurgeries: previousSurgeries,
					alcoholLevel: alcoholLevel,
					dietQuality: dietQuality,
					physicalActivityLevel: physicalActivityLevel,
					sleepHours: Int8(sleepHours),
					smoke: smoke,
					airQualityIndex: Int16(airQualityIndex),
					pollutantExposure: pollutantExposure,
					healthCareAcces: healthCareAccess,
					stresslevel: stressLevel
				)
				fetchedAssessmentData.append(assessmentItem)
			}
			print("Fetched Assessment Data: \(fetchedAssessmentData)")
			self.currentHealthAssesmentData = fetchedAssessmentData.first
		} catch let error as NSError {
			print("Error fetching assessment data: \(error.localizedDescription), code: \(error.code), domain: \(error.domain)")
		}
		
	}
	func signOut() {
		do {
			try Auth.auth().signOut()
			isAuthenticated = false
			currentUserData = nil
			currentHealthAssesmentData = nil
			currentUserHealthData = nil
			UserDefaults.standard.set(false, forKey: authStateKey)
			UserDefaults.standard.removeObject(forKey: userIdKey)
		} catch {
			print("Error signing out: \(error.localizedDescription)")
		}
	}
	
	func deleteUser( password: String, using navigationManager: NavigationManager) async {
		guard let user = Auth.auth().currentUser else {
			print("No user is currently signed in")
			return

		}
		let email = Auth.auth().currentUser?.email
		print("currentUserEmail is =>",email ?? "")
		let reAuthUser = EmailAuthProvider.credential(
			withEmail: email ?? "",
			password: password
		)
		let userId = user.uid
		let db = Firestore.firestore()
		
		do {
			//  Reauthenticate the user
			try await user.reauthenticate(with: reAuthUser)
			print("User re-authenticated successfully.")
			
			//  Delete subcollections
			try await deleteSubcollection(db.collection("users").document(userId).collection("healthData"))
			try await deleteSubcollection(db.collection("users").document(userId).collection("assessments"))
			
			//  Delete the main document
			let userRef = db.collection("users").document(userId)
			try await userRef.delete()
			print("Firebase data successfully deleted")
			
			//  Delete the Firebase Auth user
			try await user.delete()
			print("Firebase Auth user successfully deleted")
			
			// Navigate to the authentication screen
			navigationManager.switchToAuth()
		} catch {
			print("Error during deletion process: \(error.localizedDescription)")
		}
	}
	
	func deleteSubcollection(_ collection: CollectionReference) async throws {
		do {
			let snapshot = try await collection.getDocuments()
			 let documents = snapshot.documents
			if documents.isEmpty {
				print("No documents found in subcollection")
				return
			}
			
			for document in documents {
				try await document.reference.delete()
				print("Document \(document.documentID) successfully deleted")
			}
		} catch {
			print("Error fetching or deleting subcollection documents: \(error.localizedDescription)")
			throw error
		}
	}
}

