import SwiftUI
import FirebaseAuth

struct ProfileScreen: View {
    @EnvironmentObject private var authManager: AppStateManager
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var showPersonalEditSheet: Bool = false
    
    private func loadData() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        await authManager.fetchUserData(userId: userId)
        await authManager.fetchHealthData(userId: userId)
        await authManager.fetchHealthAssesment(userId: userId)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Image
                Image("MyProfileWhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                
                // Personal Data
                PersonalDataView(isEditable: $showPersonalEditSheet)
                
                // Health Data
                HealthDataView()
                
                // Assessment Data
                AssessmentDataView(navigationManager: navigationManager)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Profile")
        .task { await loadData() }
        .sheet(isPresented: $showPersonalEditSheet) {
            ProfileEditScreen()
        }
    }
}

struct PersonalDataView: View {
    @Binding var isEditable: Bool
    @EnvironmentObject private var appState: AppStateManager
    
    var body: some View {
        if let userData = appState.currentUserData {
            VStack(spacing: 15) {
                HStack {
                    Text("Personal Info")
                        .font(.headline)
                        .fontDesign(.rounded)
                    Spacer()
                    HStack {
                        Text("Edit")
                        Image(systemName: "pencil.circle")
                            .bold()
                    }
                    .onTapGesture {
                        isEditable.toggle()
                    }
                }
                ProfileData(fieldName: "Name", fieldValue: userData.fullName)
                ProfileData(fieldName: "Age", fieldValue: "\(userData.age) years")
                ProfileData(fieldName: "Height", fieldValue: "\(userData.height) cm")
                ProfileData(fieldName: "Weight", fieldValue: "\(userData.weight) kg")
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

struct HealthDataView: View {
    @EnvironmentObject private var appState: AppStateManager
    @State private var showHealthEditSheet: Bool = false
   
    var body: some View {
        if let healthData = appState.currentUserHealthData {
            VStack(spacing: 15) {
                HStack {
                    Text("Health Info")
                        .font(.headline)
                        .fontDesign(.rounded)
                    Spacer()
                    HStack {
                        Text("Edit")
                        Image(systemName: "pencil.circle")
                            .bold()
                    }
                    .onTapGesture {
                        showHealthEditSheet = true
                    }
                }
                ProfileData(fieldName: "Blood Pressure", fieldValue: "\(healthData.bloodPressure)")
                ProfileData(fieldName: "Blood Sugar", fieldValue: "\(healthData.bloodSugar)")
                ProfileData(fieldName: "cholesterol", fieldValue: "\(healthData.cholesterol)")
                ProfileData(fieldName: "Waist Circumference", fieldValue: "\(healthData.waistCircumference)")
                ProfileData(fieldName: "Heart Rate", fieldValue: "\(healthData.heartRate)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.8))
                    .shadow(radius: 5)
            )
            .padding(.horizontal)
            .sheet(isPresented: $showHealthEditSheet) {
                HealthEditScreen()
                    .environmentObject(appState)
            }
        } else {
            Text("No Health Data Found")
                .foregroundStyle(.gray)
        }
    }
}

struct AssessmentDataView: View {
    @EnvironmentObject private var appState: AppStateManager
    var navigationManager: NavigationManager
    
    var body: some View {
        if let assessmentData = appState.currentHealthAssesmentData {
            VStack(spacing: 15) {
                HStack {
                    Text("Assessment Health Info")
                        .font(.headline)
                        .fontDesign(.rounded)
                    Spacer()
                    HStack {
                        Text("Edit")
                        Image(systemName: "chevron.right")
                            .bold()
                    }
                    .onTapGesture {
                        navigationManager.pushMain(.healthAssessment)
                    }
                }
                ProfileData(fieldName: "Chronic Diseases", fieldValue: assessmentData.chronicDiseases)
                ProfileData(fieldName: "Family History of Diabetes", fieldValue: assessmentData.familyDiabetes)
                ProfileData(fieldName: "Family History of Cancer", fieldValue: assessmentData.familyHistoryCancer)
                ProfileData(fieldName: "Heart Disease", fieldValue: assessmentData.heartDisease)
                ProfileData(fieldName: "Previous Surgeries", fieldValue: assessmentData.previousSurgeries)
                ProfileData(fieldName: "Alcohol Level", fieldValue: assessmentData.alcoholLevel)
                ProfileData(fieldName: "Diet Quality", fieldValue: assessmentData.dietQuality)
                ProfileData(fieldName: "Physical Activity Level", fieldValue: assessmentData.physicalActivityLevel)
                ProfileData(fieldName: "Sleep Hours", fieldValue: "\(assessmentData.sleepHours) hours")
                ProfileData(fieldName: "Smoking", fieldValue: assessmentData.smoke)
                ProfileData(fieldName: "Air Quality Index", fieldValue: "\(assessmentData.airQualityIndex)")
                ProfileData(fieldName: "Pollutant Exposure", fieldValue: assessmentData.pollutantExposure)
                ProfileData(fieldName: "Healthcare Access", fieldValue: assessmentData.healthCareAcces)
                ProfileData(fieldName: "Stress Level", fieldValue: assessmentData.stresslevel)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.8))
                    .shadow(radius: 5)
            )
            .padding(.horizontal)
            .padding(.bottom, 30)
        } else {
            Text("No Health Assessment Data Found")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
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

#Preview {
    ProfileScreen()
}
