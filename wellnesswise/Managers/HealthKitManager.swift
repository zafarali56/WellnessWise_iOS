import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()

    func requestAuthorization() async throws {
        guard
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
            let systolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
            let diastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic),
            let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)
        else {
            throw NSError(domain: "Invalid HealthKit Types", code: -1, userInfo: nil)
        }

        let readTypes: Set<HKObjectType> = [heartRateType, systolicType, diastolicType, bloodGlucoseType]

        try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
                if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: error ?? NSError(
                        domain: "HKAuthorizationError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to authorize HealthKit"]
                    ))
                }
            }
        }
    }

    func retrieveLatest(for typeIdentifier: HKQuantityTypeIdentifier, unit: HKUnit) async throws -> Double {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: typeIdentifier) else {
            throw NSError(domain: "Invalid Type", code: -1, userInfo: nil)
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let sample = samples?.first as? HKQuantitySample {
                    let value = sample.quantity.doubleValue(for: unit)
                    continuation.resume(returning: value)
                } else {
                    continuation.resume(throwing: error ?? NSError(
                        domain: "No Data",
                        code: -1,
                        userInfo: nil
                    ))
                }
            }
            healthStore.execute(query)
        }
    }

    // Convenience methods
    func retrieveLatestHeartRate() async throws -> Double {
        try await retrieveLatest(for: .heartRate, unit: HKUnit.count().unitDivided(by: .minute()))
    }

    func retrieveLatestSystolic() async throws -> Double {
        try await retrieveLatest(for: .bloodPressureSystolic, unit: HKUnit.millimeterOfMercury())
    }

    func retrieveLatestDiastolic() async throws -> Double {
        try await retrieveLatest(for: .bloodPressureDiastolic, unit: HKUnit.millimeterOfMercury())
    }

    func retrieveLatestBloodGlucose() async throws -> Double {
        try await retrieveLatest(for: .bloodGlucose, unit: HKUnit(from: "mg/dL"))
    }
}
