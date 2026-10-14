import SwiftUI

struct OnboardingView: View {
    @ObservedObject var session = GotChoresSession.shared
    @Binding var navigationRoute: AppRoute
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.23, green: 0.51, blue: 0.96), Color(red: 0.15, green: 0.39, blue: 0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                Spacer()
                
                VStack(spacing: 12) {
                    Image("wordmark")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 120)
                        .padding(.horizontal, 30)
                    
                    Text("Make chores fun!")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Who's using this phone?")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(UIColor.label))
                    
                    Text("Kids can join without an account — just scan the code your grown-up shows you.")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .padding(.horizontal, 10)
                    
                    Button(action: {
                        navigationRoute = .kidPairing
                    }) {
                        HStack {
                            Text("🧒")
                                .font(.system(size: 22))
                            Text("I'm a Kid")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    Button(action: {
                        if session.parentPinHash != nil {
                            navigationRoute = .parentPasscode
                        } else {
                            navigationRoute = .parentSetup
                        }
                    }) {
                        HStack {
                            Text("👨‍👩‍👧")
                                .font(.system(size: 22))
                            Text("I'm a Parent")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(UIColor.secondarySystemBackground))
                        .foregroundColor(Color.blue)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1.5)
                        )
                    }
                }
                .padding(24)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}
