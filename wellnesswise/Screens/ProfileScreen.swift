import SwiftUI
import FirebaseAuth

struct ProfileScreen: View {
	
	private func loadData()async{
		guard let userId = Auth.auth().currentUser?.uid else {return }
		await authManager.fetchUserData(userId: userId)
		await authManager.fetchHealthData(userId: userId)
		await authManager.fetchHealthAssesment(userId: userId)
	
	}
	@EnvironmentObject private var authManager: AppStateManager
	@EnvironmentObject private var navigationManager: NavigationManager
	@State private var showEditingSheet : Bool = false
	var body: some View {
		ScrollView {
		
			Image("MyProfileWhite")
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 100)
				.clipShape(Circle())
				.overlay(
					Circle().stroke(Color.white, lineWidth: 4)
				)
				.shadow(radius: 10)
			
			
			Personal_Data(isPersonalDataEditable: $showEditingSheet)
			Health_Data()
			Assesment_Data(navigationManager: navigationManager)
			
		}
		.navigationTitle("Profile")
		.padding(.horizontal)
		.task { await loadData()}
		.sheet(isPresented: $showEditingSheet){
			ProfileEditScreen()
		}
	}	
}
private struct Health_Data : View {
	@StateObject var appState = AppStateManager.shared
	
	var body: some View {
		if let healthData = appState.currentUserHealthData {
			VStack (spacing: 15){
				HStack {
					Text("Health Info")
						.font(.headline)
						.fontDesign(.rounded)
					
					Spacer()
					Text("Edit")
					Image(systemName: "pencil.circle")
						.bold()
						.onTapGesture {
						//Navigatete health info edit screen
						}
				}
				
				
				ProfileData	(
					fieldName: "Blood Pressure",
					fieldValue: "\(healthData.bloodPressure)"
				)
				ProfileData(
					fieldName: "Blood Sugar",
					fieldValue: "\(healthData.bloodSugar)"
				)
				ProfileData(
					fieldName: "Cholestrol",
					fieldValue: "\(healthData.cholestrol)"
				)
				ProfileData(
					fieldName: "Waist Circumference",
					fieldValue: "\(healthData.waistCircumference)"
				)
				ProfileData(
					fieldName: "Heart Rate",
					fieldValue: "\(healthData.heartRate)"
				)
			}				.padding()
				.background(
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.white.opacity(0.8))
						.shadow(radius: 5)
				)
				.padding(.horizontal)
		}
		else{
			Text("No Health Data Found")
				.foregroundStyle(.gray)
		}
	}
}
private struct Assesment_Data: View {
	@StateObject var appState = AppStateManager.shared
	@ObservedObject var navigationManager : NavigationManager
	var body: some View {
		if let assessmentData = appState.currentHealthAssesmentData {
			VStack(spacing: 15) {
				HStack {
					Text("Assessment health info")
						.font(.headline)
						.fontDesign(.rounded)
					
					Spacer()
					HStack{
						Text("Edit")
						Image(systemName: "chevron.right")
							.bold()
					}.onTapGesture {
						navigationManager.pushMain(.healthAssessment)
					}

				}
				
				ProfileData(
					fieldName: "Chronic Diseases",
					fieldValue: assessmentData.chronicDiseases
				)
				ProfileData(
					fieldName: "Family History of Diabetes",
					fieldValue: assessmentData.familyDiabetes
				)
				ProfileData(
					fieldName: "Family History of Cancer",
					fieldValue: assessmentData.familyHistoryCancer
				)
				ProfileData(
					fieldName: "Heart Disease",
					fieldValue: assessmentData.heartDisease
				)
				ProfileData(
					fieldName: "Previous Surgeries",
					fieldValue: assessmentData.previousSurgeries
				)
				ProfileData(
					fieldName: "Alcohol Level",
					fieldValue: assessmentData.alcoholLevel
				)
				ProfileData(
					fieldName: "Diet Quality",
					fieldValue: assessmentData.dietQuality
				)
				ProfileData(
					fieldName: "Physical Activity Level",
					fieldValue: assessmentData.physicalActivityLevel
				)
				ProfileData(
					fieldName: "Sleep Hours",
					fieldValue: "\(assessmentData.sleepHours) hours"
				)
				ProfileData(
					fieldName: "Smoking",
					fieldValue: assessmentData.smoke
				)
				ProfileData(
					fieldName: "Air Quality Index",
					fieldValue: "\(assessmentData.airQualityIndex)"
				)
				ProfileData(
					fieldName: "Pollutant Exposure",
					fieldValue: assessmentData.pollutantExposure
				)
				ProfileData(
					fieldName: "Healthcare Access",
					fieldValue: assessmentData.healthCareAcces
				)
				ProfileData(
					fieldName: "Stress Level",
					fieldValue: assessmentData.stresslevel
				)
			}
			.padding()
			.background(
				RoundedRectangle(cornerRadius: 20)
					.fill(Color.white.opacity(0.8))
					.shadow(radius: 5)
			)
			.padding(.horizontal)
			.padding(.bottom,30)
		} else {
			Text("No Health Assessment Data Found")
				.foregroundStyle(.gray)
				.multilineTextAlignment(.center)
				.padding()
		}
	}
}
private struct Personal_Data: View {
	@Binding  var isPersonalDataEditable : Bool
	@StateObject var appState = AppStateManager.shared
	@State var showEditingView : Bool = false
	

	
	var body: some View {
		VStack(spacing: 15) {
			if let userData = appState.currentUserData {
				VStack(spacing: 15) {
					HStack {
						Text("Personal info")
							.font(.headline)
							.fontDesign(.rounded)
						Spacer()
						HStack{
							Text("Edit")
							Image(systemName: "pencil.circle")
							
								.bold()
						}.onTapGesture {
							isPersonalDataEditable.toggle()
						}
					}
					ProfileData(fieldName: "Name", fieldValue: userData.fullName)
					ProfileData(fieldName: "Age", fieldValue: "\(userData.age) -/years")
					ProfileData(fieldName: "Height", fieldValue: "\(userData.height) -/cm")
					ProfileData(fieldName: "Weight", fieldValue: "\(userData.weight) -/kg")
					ProfileData(fieldName: "Gender", fieldValue: userData.gender)
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 20)
						.fill(Color.white.opacity(0.8))
						.shadow(radius: 5)
				)
				.padding(.horizontal)
			} else {
				Text("No user data available")
					.foregroundStyle(.gray)
			}
		}
	}
}



#Preview {
	ProfileScreen()
}
struct ProfileData: View {
	var fieldName: String
	var fieldValue: String
	
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
		.padding(.horizontal)
		
	}
	}


