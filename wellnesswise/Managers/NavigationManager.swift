import SwiftUI
enum NavigationType: Hashable {
	case authentication
	case main
}
enum AuthenticationRoute: Hashable {
	case login
	case signup
	case verification

}

enum MainRoute: Hashable {
	case home
	case profile
	case healthAssessment
	case healthDataScreen
}
@MainActor
class NavigationManager: ObservableObject {
	static let shared = NavigationManager()
	
	@Published var navigationType: NavigationType = .authentication
	@Published var authenticationPath = NavigationPath()
	@Published var mainPath = NavigationPath()
	
	private init() {}
	
	func switchToMain() {
		DispatchQueue.main.async { [weak self] in
			self?.navigationType = .main
			self?.mainPath = NavigationPath()
		}
	}
	
	func switchToAuth() {
		DispatchQueue.main.async { [weak self] in
			self?.navigationType = .authentication
			self?.authenticationPath = NavigationPath()
		}
	}
	
	func pushAuthentication(_ route: AuthenticationRoute) {
		DispatchQueue.main.async { [weak self] in
			self?.authenticationPath.append(route)
		}
	}
	
	func pushMain(_ route: MainRoute) {
		DispatchQueue.main.async { [weak self] in
			self?.mainPath.append(route)
		}
	}
	
	func popToRoot() {
		DispatchQueue.main.async { [weak self] in
			switch self?.navigationType {
			case .authentication:
				self?.authenticationPath = NavigationPath()
			case .main:
				self?.mainPath = NavigationPath()
			case .none:
				break
			}
		}
	}
}
