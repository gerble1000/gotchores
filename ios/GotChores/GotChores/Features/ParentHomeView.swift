import SwiftUI

struct ParentHomeView: View {
    @ObservedObject var session = GotChoresSession.shared
    @Binding var navigationRoute: AppRoute
    
    @State private var selectedTab: Int = 0
    @State private var kids: [ChildDto] = [
        ChildDto(id: 1, name: "Alex", username: "alex", role: "kid", avatar: "🧒"),
        ChildDto(id: 2, name: "Emma", username: "emma", role: "kid", avatar: "👧")
    ]
    @State private var pendingApprovals: [ChoreItem] = [
        ChoreItem(id: "1", choreId: 102, assignmentId: 2, title: "Clean Bedroom Floor", description: "Alex submitted proof", icon: "🧹", rewardPoints: 50, dueDate: "Today", dueTime: "18:00", proofRequired: true, isOptional: false, assignmentStatus: "pending_approval", completedAt: "17:45")
    ]
    @State private var qrCodeValue: String = "1234"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard / Approvals
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Household stats
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.householdName.isEmpty ? "Miller Family Hub" : "\(session.householdName) Hub")
                                    .font(.system(size: 24, weight: .black))
                                Text("Parent Command Center")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            Button(action: {
                                session.isParentUnlocked = false
                                navigationRoute = .onboarding
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "lock.fill")
                                    Text("Lock")
                                }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Approvals section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pending Approvals (\(pendingApprovals.count))")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.horizontal, 20)
                            
                            if pendingApprovals.isEmpty {
                                Text("All caught up! No chores waiting for review.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)
                            } else {
                                ForEach(pendingApprovals) { item in
                                    ApprovalCard(item: item) {
                                        approveItem(item)
                                    }
                                }
                            }
                        }
                        
                        // Family Members
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Children")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.horizontal, 20)
                            
                            ForEach(kids) { kid in
                                HStack(spacing: 14) {
                                    Text(kid.avatar ?? "🧒")
                                        .font(.system(size: 32))
                                        .frame(width: 48, height: 48)
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(kid.name)
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Active Missions")
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("120 🪙")
                                        .font(.system(size: 16, weight: .black))
                                        .foregroundColor(.blue)
                                }
                                .padding(14)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .navigationTitle("Parent Hub")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Command", systemImage: "shield.fill")
            }
            .tag(0)
            
            // Pair Kid Tab (Wi-Fi QR code display)
            NavigationView {
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Text("📱")
                            .font(.system(size: 48))
                        Text("Pair a Child Phone")
                            .font(.system(size: 24, weight: .bold))
                        Text("On the child's phone, select 'I'm a Kid' and scan this code or type the 4-digit code.")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 32)
                    }
                    
                    // QR Code Card
                    VStack(spacing: 16) {
                        Image(systemName: "qrcode")
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                        
                        Text("PAIRING CODE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Text(qrCodeValue)
                            .font(.system(size: 36, weight: .heavy, design: .monospaced))
                            .foregroundColor(.blue)
                            .tracking(8)
                    }
                    .padding(24)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(24)
                    
                    Spacer()
                }
                .navigationTitle("Pair Device")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Pairing", systemImage: "qrcode")
            }
            .tag(1)
        }
    }
    
    private func approveItem(_ item: ChoreItem) {
        pendingApprovals.removeAll(where: { $0.id == item.id })
    }
}

struct ApprovalCard: View {
    let item: ChoreItem
    let onApprove: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Text(item.icon ?? "📝")
                .font(.system(size: 32))
                .frame(width: 48, height: 48)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                Text("+\(item.rewardPoints) points • \(item.description ?? "")")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Button(action: onApprove) {
                Text("Approve")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(14)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}
