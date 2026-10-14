import SwiftUI

enum AppRoute {
    case onboarding
    case kidPairing
    case parentSetup
    case parentPasscode
    case kidHome
    case parentHome
}

@main
struct GotChoresApp: App {
    @StateObject private var session = GotChoresSession.shared
    @State private var navigationRoute: AppRoute = .onboarding
    
    init() {
        // Configure standard appearance
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemBlue
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch navigationRoute {
                case .onboarding:
                    OnboardingView(navigationRoute: $navigationRoute)
                case .kidPairing:
                    PairScreenView(navigationRoute: $navigationRoute)
                case .parentSetup:
                    ParentSetupView(navigationRoute: $navigationRoute)
                case .parentPasscode:
                    PasscodeScreenView(navigationRoute: $navigationRoute)
                case .kidHome:
                    KidHomeView(navigationRoute: $navigationRoute)
                case .parentHome:
                    ParentHomeView(navigationRoute: $navigationRoute)
                }
            }
            .environmentObject(session)
            .onAppear {
                if session.isPaired {
                    navigationRoute = .kidHome
                } else if session.parentPinHash != nil && session.isParentUnlocked {
                    navigationRoute = .parentHome
                } else {
                    navigationRoute = .onboarding
                }
            }
        }
    }
}
