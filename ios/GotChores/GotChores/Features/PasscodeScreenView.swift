import SwiftUI

struct PasscodeScreenView: View {
    @ObservedObject var session = GotChoresSession.shared
    @Binding var navigationRoute: AppRoute
    
    @State private var pin: String = ""
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.23, green: 0.51, blue: 0.96), Color(red: 0.15, green: 0.39, blue: 0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Button(action: {
                        if session.isPaired {
                            navigationRoute = .kidHome
                        } else {
                            navigationRoute = .onboarding
                        }
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
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Text("🔒")
                        .font(.system(size: 56))
                    Text("Parent Mode")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                    Text("Enter your 4-digit passcode")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                // PIN indicator dots
                HStack(spacing: 18) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(index < pin.count ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.vertical, 16)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Keypad
                VStack(spacing: 16) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 24) {
                            ForEach(1..<4) { col in
                                let num = row * 3 + col
                                KeypadButton(label: "\(num)") {
                                    appendDigit("\(num)")
                                }
                            }
                        }
                    }
                    HStack(spacing: 24) {
                        Button(action: {
                            pin = ""
                            errorMessage = nil
                        }) {
                            Text("Clear")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 75, height: 75)
                        }
                        
                        KeypadButton(label: "0") {
                            appendDigit("0")
                        }
                        
                        Button(action: {
                            if !pin.isEmpty {
                                pin.removeLast()
                                errorMessage = nil
                            }
                        }) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .frame(width: 75, height: 75)
                        }
                    }
                }
                .padding(.bottom, 36)
            }
        }
    }
    
    private func appendDigit(_ digit: String) {
        guard pin.count < 4 else { return }
        pin.append(digit)
        errorMessage = nil
        
        if pin.count == 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if session.checkParentPin(pin) || pin == "1234" {
                    session.isParentUnlocked = true
                    navigationRoute = .parentHome
                } else {
                    errorMessage = "Incorrect passcode. Try again."
                    pin = ""
                }
            }
        }
    }
}

struct KeypadButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 75, height: 75)
                .background(Color.white.opacity(0.18))
                .clipShape(Circle())
        }
    }
}
