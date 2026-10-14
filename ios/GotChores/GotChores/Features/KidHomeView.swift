import SwiftUI

struct KidHomeView: View {
    @ObservedObject var session = GotChoresSession.shared
    @Binding var navigationRoute: AppRoute
    
    @State private var selectedTab: Int = 0
    @State private var chores: [ChoreItem] = [
        ChoreItem(id: "1", choreId: 101, assignmentId: 1, title: "Make Bed", description: "Straighten sheets and arrange pillows", icon: "🛏️", rewardPoints: 20, dueDate: "Today", dueTime: "10:00", proofRequired: false, isOptional: false, assignmentStatus: "assigned", completedAt: nil),
        ChoreItem(id: "2", choreId: 102, assignmentId: 2, title: "Clean Bedroom Floor", description: "Put all toys in the storage bin", icon: "🧹", rewardPoints: 50, dueDate: "Today", dueTime: "18:00", proofRequired: true, isOptional: false, assignmentStatus: "assigned", completedAt: nil),
        ChoreItem(id: "3", choreId: 103, assignmentId: 3, title: "Feed Family Pet", description: "Fill water and scoop dry food", icon: "🐾", rewardPoints: 30, dueDate: "Today", dueTime: "19:00", proofRequired: false, isOptional: true, assignmentStatus: "assigned", completedAt: nil)
    ]
    @State private var rewards: [RewardItem] = [
        RewardItem(id: 1, title: "30 Min Screen Time", description: "Extra iPad or gaming time", icon: "🎮", pointsRequired: 50, claimedToday: false),
        RewardItem(id: 2, title: "Trip to Ice Cream Shop", description: "1 double scoop cone", icon: "🍦", pointsRequired: 150, claimedToday: false),
        RewardItem(id: 3, title: "Pick Movie Night Film", description: "Choose what the whole family watches", icon: "🎬", pointsRequired: 100, claimedToday: false)
    ]
    @State private var showCelebration: Bool = false
    @State private var celebrationText: String = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Missions Tab
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Profile Bar
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello, \(session.childName.isEmpty ? "Alex" : session.childName)! 🌟")
                                    .font(.system(size: 24, weight: .black))
                                Text(session.householdName.isEmpty ? "Miller Family" : session.householdName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            // Points Pill
                            HStack(spacing: 6) {
                                Text("🪙")
                                    .font(.system(size: 20))
                                Text("\(session.points == 0 ? 120 : session.points)")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.12))
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Chore Missions Card
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Today's Missions")
                                .font(.system(size: 18, weight: .bold))
                                .padding(.horizontal, 20)
                            
                            ForEach(chores) { chore in
                                ChoreRow(chore: chore) {
                                    completeChore(chore)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .navigationTitle("Missions")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            navigationRoute = .parentPasscode
                        }) {
                            Text("Parent")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .tabItem {
                Label("Missions", systemImage: "checkmark.circle.fill")
            }
            .tag(0)
            
            // Rewards Tab
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Available Points:")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("🪙 \(session.points == 0 ? 120 : session.points)")
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        ForEach(rewards) { reward in
                            RewardRow(reward: reward, currentPoints: session.points == 0 ? 120 : session.points) {
                                claimReward(reward)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .navigationTitle("Rewards Store")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Rewards", systemImage: "gift.fill")
            }
            .tag(1)
        }
        .overlay(
            Group {
                if showCelebration {
                    CelebrationOverlay(text: celebrationText) {
                        showCelebration = false
                    }
                }
            }
        )
    }
    
    private func completeChore(_ chore: ChoreItem) {
        if let idx = chores.firstIndex(where: { $0.id == chore.id }) {
            chores[idx].assignmentStatus = "completed"
            let earned = chore.rewardPoints
            session.updatePoints((session.points == 0 ? 120 : session.points) + earned)
            celebrationText = "Awesome Job!\n+\(earned) Points"
            showCelebration = true
        }
    }
    
    private func claimReward(_ reward: RewardItem) {
        let current = session.points == 0 ? 120 : session.points
        if current >= reward.pointsRequired {
            session.updatePoints(current - reward.pointsRequired)
            celebrationText = "Reward Claimed!\n\(reward.title)"
            showCelebration = true
        }
    }
}

struct ChoreRow: View {
    let chore: ChoreItem
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Text(chore.icon ?? "📝")
                .font(.system(size: 32))
                .frame(width: 48, height: 48)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chore.title)
                    .font(.system(size: 16, weight: .bold))
                if let desc = chore.description {
                    Text(desc)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if chore.assignmentStatus == "completed" {
                Text("Done ✅")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.green)
            } else {
                Button(action: onComplete) {
                    HStack(spacing: 4) {
                        Text("+\(chore.rewardPoints)")
                            .font(.system(size: 14, weight: .black))
                        Text("🪙")
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
        .padding(14)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}

struct RewardRow: View {
    let reward: RewardItem
    let currentPoints: Int
    let onClaim: () -> Void
    
    var canAfford: Bool {
        currentPoints >= reward.pointsRequired
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Text(reward.icon ?? "🎁")
                .font(.system(size: 32))
                .frame(width: 48, height: 48)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reward.title)
                    .font(.system(size: 16, weight: .bold))
                if let desc = reward.description {
                    Text(desc)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button(action: onClaim) {
                Text("\(reward.pointsRequired) 🪙")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(canAfford ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(canAfford ? .white : .gray)
                    .cornerRadius(12)
            }
            .disabled(!canAfford)
        }
        .padding(14)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}

struct CelebrationOverlay: View {
    let text: String
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack(spacing: 18) {
                Text("🎉")
                    .font(.system(size: 64))
                Text(text)
                    .font(.system(size: 22, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Button(action: onDismiss) {
                    Text("Woohoo!")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 140, height: 46)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(14)
                }
            }
            .padding(32)
            .background(Color(red: 0.15, green: 0.2, blue: 0.3))
            .cornerRadius(24)
            .padding(32)
        }
    }
}
