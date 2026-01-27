//
//  MenuBarView.swift
//  clockwork
//

import SwiftUI

// MARK: - Design System

struct ClockworkColors {
    static let background = Color(red: 0.08, green: 0.08, blue: 0.10)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.14)
    static let gold = Color(red: 0.85, green: 0.70, blue: 0.35)
    static let goldLight = Color(red: 0.95, green: 0.85, blue: 0.55)
    static let success = Color(red: 0.30, green: 0.75, blue: 0.55)
    static let warning = Color(red: 0.95, green: 0.65, blue: 0.25)
    static let danger = Color(red: 0.85, green: 0.35, blue: 0.40)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.55)
    static let textTertiary = Color(white: 0.35)
    static let divider = Color(white: 0.20)
}

// MARK: - Main View

struct MenuBarView: View {
    @EnvironmentObject var timerManager: TimerManager
    @State private var rateInput: String = ""
    @State private var showSettings: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            timerSection
            controlsSection

            if showSettings {
                settingsSection
            }

            sessionsSection
        }
        .frame(width: 320, height: 520)
        .background(ClockworkColors.background)
        .ignoresSafeArea(.container, edges: [.top, .bottom])
        .padding(.top, -4)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .center) {
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ClockworkColors.gold)

                Text("CLOCKWORK")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(2)
                    .foregroundColor(ClockworkColors.textPrimary)
            }

            Spacer()

            HStack(spacing: 12) {
                Button(action: { withAnimation(.easeInOut(duration: 0.2)) { showSettings.toggle() } }) {
                    Image(systemName: showSettings ? "gearshape.fill" : "gearshape")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(showSettings ? ClockworkColors.gold : ClockworkColors.textSecondary)
                        .rotationEffect(.degrees(showSettings ? 90 : 0))
                        .animation(.easeInOut(duration: 0.3), value: showSettings)
                }
                .buttonStyle(.plain)

                Button(action: { NSApplication.shared.terminate(nil) }) {
                    Image(systemName: "power")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ClockworkColors.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [ClockworkColors.cardBackground, ClockworkColors.background],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Timer Display

    private var timerSection: some View {
        VStack(spacing: 4) {
            // Status indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 6, height: 6)
                    .shadow(color: statusColor.opacity(0.6), radius: 4)

                Text(statusText)
                    .font(.system(size: 10, weight: .medium))
                    .tracking(1.5)
                    .foregroundColor(ClockworkColors.textSecondary)
                    .textCase(.uppercase)
            }
            .padding(.top, 8)

            // Main timer
            Text(timerManager.formattedElapsedTime)
                .font(.system(size: 52, weight: .thin, design: .monospaced))
                .foregroundColor(ClockworkColors.textPrimary)
                .shadow(color: timerManager.isRunning ? ClockworkColors.gold.opacity(0.3) : .clear, radius: 20)
                .padding(.vertical, 4)

            // Earnings display
            if timerManager.currentSession != nil {
                HStack(spacing: 4) {
                    Text(timerManager.formattedCurrentEarnings)
                        .font(.system(size: 24, weight: .light, design: .rounded))
                        .foregroundColor(ClockworkColors.gold)

                    Text("earned")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(ClockworkColors.textTertiary)
                        .padding(.top, 6)
                }
            } else {
                Text("@ $\(String(format: "%.0f", timerManager.hourlyRate))/hr")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(ClockworkColors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    timerManager.isRunning
                        ? LinearGradient(
                            colors: [ClockworkColors.gold.opacity(0.08), ClockworkColors.background],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        : LinearGradient(colors: [ClockworkColors.background, ClockworkColors.background], startPoint: .top, endPoint: .bottom)
                )
        )
    }

    private var statusColor: Color {
        if timerManager.isPaused { return ClockworkColors.warning }
        if timerManager.isRunning { return ClockworkColors.success }
        return ClockworkColors.textTertiary
    }

    private var statusText: String {
        if timerManager.isPaused { return "Paused" }
        if timerManager.isRunning { return "Running" }
        return "Ready"
    }

    // MARK: - Controls

    private var controlsSection: some View {
        HStack(spacing: 10) {
            if timerManager.currentSession == nil {
                ClockworkButton(
                    title: "Start Session",
                    icon: "play.fill",
                    style: .primary
                ) {
                    timerManager.startSession()
                }
            } else {
                if timerManager.isPaused {
                    ClockworkButton(
                        title: "Resume",
                        icon: "play.fill",
                        style: .primary
                    ) {
                        timerManager.resumeSession()
                    }
                } else {
                    ClockworkButton(
                        title: "Pause",
                        icon: "pause.fill",
                        style: .secondary
                    ) {
                        timerManager.pauseSession()
                    }
                }

                ClockworkButton(
                    title: "End",
                    icon: "stop.fill",
                    style: .danger
                ) {
                    timerManager.endSession()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text("HOURLY RATE")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundColor(ClockworkColors.textTertiary)

            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text("$")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(ClockworkColors.gold)

                    TextField("0.00", text: $rateInput)
                        .textFieldStyle(.plain)
                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                        .foregroundColor(ClockworkColors.textPrimary)
                        .frame(width: 70)
                        .onAppear {
                            rateInput = String(format: "%.2f", timerManager.hourlyRate)
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(ClockworkColors.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(ClockworkColors.divider, lineWidth: 1)
                        )
                )

                Spacer()

                Button(action: {
                    if let rate = Double(rateInput) {
                        timerManager.updateHourlyRate(rate)
                    }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showSettings = false
                    }
                }) {
                    Text("Update")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ClockworkColors.gold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(ClockworkColors.gold.opacity(0.5), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            }

            if !timerManager.sessions.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("DANGER ZONE")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(1.5)
                        .foregroundColor(ClockworkColors.textTertiary)

                    Button(action: { timerManager.clearAllSessions() }) {
                        HStack {
                            Image(systemName: "trash")
                                .font(.system(size: 12, weight: .medium))
                            Text("Clear All Sessions")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(ClockworkColors.danger)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(ClockworkColors.danger.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(ClockworkColors.cardBackground)
    }

    // MARK: - Sessions

    private var sessionsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("PAST SESSIONS")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundColor(ClockworkColors.textTertiary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(ClockworkColors.cardBackground)

            Rectangle()
                .fill(ClockworkColors.divider)
                .frame(height: 1)

            if timerManager.sessions.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(ClockworkColors.textTertiary)
                    Text("No sessions yet")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(ClockworkColors.textTertiary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(timerManager.sessions) { session in
                            SessionRow(session: session) {
                                timerManager.deleteSession(session)
                            }

                            if session.id != timerManager.sessions.last?.id {
                                Rectangle()
                                    .fill(ClockworkColors.divider)
                                    .frame(height: 1)
                                    .padding(.leading, 16)
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - Session Row

struct SessionRow: View {
    let session: Session
    let onDelete: () -> Void
    @State private var dragOffset: CGFloat = 0
    @State private var isRevealed: Bool = false
    @State private var showDeleteConfirm: Bool = false
    private let revealWidth: CGFloat = 64

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button(action: { showDeleteConfirm = true }) {
                    Image(systemName: "trash")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ClockworkColors.textPrimary)
                        .frame(width: revealWidth, height: 44)
                        .background(ClockworkColors.danger)
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
            .background(ClockworkColors.cardBackground)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(timeRangeText)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                        .foregroundColor(ClockworkColors.textSecondary)

                    Text(session.formattedDuration)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(ClockworkColors.textPrimary)
                }

                Spacer()

                Text(session.formattedEarnings)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(ClockworkColors.gold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(ClockworkColors.background)
            .offset(x: dragOffset)
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        let base = isRevealed ? -revealWidth : 0
                        let proposed = base + value.translation.width
                        dragOffset = min(0, max(proposed, -revealWidth))
                    }
                    .onEnded { _ in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if -dragOffset > revealWidth * 0.5 {
                                isRevealed = true
                                dragOffset = -revealWidth
                            } else {
                                isRevealed = false
                                dragOffset = 0
                            }
                        }
                    }
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        if isRevealed {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isRevealed = false
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .alert("Delete session?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isRevealed = false
                    dragOffset = 0
                }
                onDelete()
            }
            Button("Cancel", role: .cancel) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isRevealed = false
                    dragOffset = 0
                }
            }
        } message: {
            Text("This cannot be undone.")
        }
    }

    private var timeRangeText: String {
        if let end = session.formattedEndTime {
            return "\(session.formattedStartTime) – \(end)"
        }
        return session.formattedStartTime
    }
}

// MARK: - Custom Button

enum ClockworkButtonStyle {
    case primary, secondary, danger
}

struct ClockworkButton: View {
    let title: String
    let icon: String
    let style: ClockworkButtonStyle
    let action: () -> Void

    @State private var isHovering: Bool = false
    @State private var isPressed: Bool = false

    private var backgroundColor: Color {
        switch style {
        case .primary: return ClockworkColors.gold
        case .secondary: return ClockworkColors.cardBackground
        case .danger: return ClockworkColors.danger.opacity(0.15)
        }
    }

    private var hoverColor: Color {
        switch style {
        case .primary: return ClockworkColors.goldLight
        case .secondary: return ClockworkColors.divider
        case .danger: return ClockworkColors.danger.opacity(0.25)
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return ClockworkColors.background
        case .secondary: return ClockworkColors.textPrimary
        case .danger: return ClockworkColors.danger
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary: return Color.clear
        case .secondary: return ClockworkColors.divider
        case .danger: return ClockworkColors.danger.opacity(0.3)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovering ? hoverColor : backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }
}

#Preview {
    MenuBarView()
        .environmentObject(TimerManager())
}
