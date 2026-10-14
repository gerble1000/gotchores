import SwiftUI

struct ParentSetupView: View {
    @ObservedObject var session = GotChoresSession.shared
    @Binding var navigationRoute: AppRoute
    
    @State private var familyName: String = ""
    @State private var passcode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.23, green: 0.51, blue: 0.96), Color(red: 0.15, green: 0.39, blue: 0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            navigationRoute = .onboarding
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    VStack(spacing: 10) {
                        Text("🏡")
                            .font(.system(size: 52))
                        Text("Set up your family")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(.white)
                        Text("This phone becomes your family hub. Kid phones link to it over Wi-Fi — no internet or accounts needed.")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 24)
                    }
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Family Name (Optional)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                            TextField("e.g. Miller Family", text: $familyName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("4-Digit Passcode")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                            SecureField("Enter 4 digits", text: $passcode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Confirm Passcode")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                            SecureField("Re-enter 4 digits", text: $confirmPasscode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                        
                        if let error = errorMessage {
                            Text(error)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            saveSetup()
                        }) {
                            Text("Finish Setup")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    private func saveSetup() {
        if passcode.count != 4 {
            errorMessage = "Passcode must be exactly 4 digits."
            return
        }
        if passcode != confirmPasscode {
            errorMessage = "Passcodes do not match."
            return
        }
        
        session.setParentPin(passcode)
        session.householdName = familyName.isEmpty ? "My Family" : familyName
        session.isParentUnlocked = true
        navigationRoute = .parentHome
    }
}
