import SwiftUI

struct PairScreenView: View {
    @ObservedObject var session = GotChoresSession.shared
    @Binding var navigationRoute: AppRoute
    
    @State private var manualCode: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.23, green: 0.51, blue: 0.96), Color(red: 0.15, green: 0.39, blue: 0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
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
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                VStack(spacing: 8) {
                    Text("📷")
                        .font(.system(size: 52))
                    Text("Scan Parent Code")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.white)
                    Text("Ask your grown-up to open Parent Hub and show you their QR code.")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // Camera scanner mock / manual entry fallback card
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.85))
                            .frame(height: 240)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 64))
                                .foregroundColor(.blue)
                            Text("Point camera at Parent QR")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text("Or enter code manually:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    
                    HStack(spacing: 12) {
                        TextField("6-digit code", text: $manualCode)
                            .keyboardType(.numberPad)
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .frame(height: 50)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                            .padding(.horizontal, 8)
                        
                        Button(action: {
                            submitPairing(code: manualCode)
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Pair")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .frame(width: 80, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(manualCode.count < 4 || isLoading)
                    }
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
                .padding(24)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
    }
    
    private func submitPairing(code: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let res = try await GotChoresApi.shared.pairWithCode(code: code)
                await MainActor.run {
                    isLoading = false
                    if res.success, let child = res.child, let token = res.deviceToken {
                        session.savePairing(
                            household: res.household?.name ?? "My Family",
                            child: child.name,
                            token: token,
                            pinHash: res.parentPinHash
                        )
                        navigationRoute = .kidHome
                    } else {
                        errorMessage = res.message ?? "Invalid pairing code. Please try again."
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    // Demo fallback if offline/mock code entered
                    if code == "1234" || code == "123456" {
                        session.savePairing(
                            household: "Miller Family",
                            child: "Alex",
                            token: "demo_kid_token_ios",
                            pinHash: GotChoresSession.hashPin("1234")
                        )
                        navigationRoute = .kidHome
                    } else {
                        errorMessage = "Could not reach Parent Hub over Wi-Fi. (Tip: Try demo code 1234)"
                    }
                }
            }
        }
    }
}
