//
//  TimerManager.swift
//  clockwork
//

import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var currentSession: Session?
    @Published var sessions: [Session] = []
    @Published var isPaused: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var hourlyRate: Double = 100.0

    private var timer: Timer?
    private var pauseStartTime: Date?

    private let sessionsKey = "clockwork_sessions"
    private let rateKey = "clockwork_hourly_rate"

    init() {
        loadData()
    }

    var isRunning: Bool {
        return currentSession != nil && !isPaused
    }

    var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var currentEarnings: Double {
        return (elapsedTime / 3600.0) * hourlyRate
    }

    var formattedCurrentEarnings: String {
        return String(format: "$%.2f", currentEarnings)
    }

    func startSession() {
        currentSession = Session(hourlyRate: hourlyRate)
        isPaused = false
        elapsedTime = 0
        startTimer()
    }

    func pauseSession() {
        guard currentSession != nil, !isPaused else { return }
        isPaused = true
        pauseStartTime = Date()
        stopTimer()
    }

    func resumeSession() {
        guard var session = currentSession, isPaused, let pauseStart = pauseStartTime else { return }
        let pauseDuration = Date().timeIntervalSince(pauseStart)
        session.totalPausedDuration += pauseDuration
        currentSession = session
        isPaused = false
        pauseStartTime = nil
        startTimer()
    }

    func endSession() {
        guard var session = currentSession else { return }

        if isPaused, let pauseStart = pauseStartTime {
            session.totalPausedDuration += Date().timeIntervalSince(pauseStart)
        }

        session.endTime = Date()
        sessions.insert(session, at: 0)
        saveData()

        currentSession = nil
        isPaused = false
        pauseStartTime = nil
        elapsedTime = 0
        stopTimer()
    }

    func deleteSession(_ session: Session) {
        sessions.removeAll { $0.id == session.id }
        saveData()
    }

    func clearAllSessions() {
        sessions.removeAll()
        saveData()
    }

    func updateHourlyRate(_ rate: Double) {
        hourlyRate = rate
        UserDefaults.standard.set(rate, forKey: rateKey)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateElapsedTime() {
        guard let session = currentSession else { return }
        elapsedTime = session.duration
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([Session].self, from: data) {
            sessions = decoded
        }

        let savedRate = UserDefaults.standard.double(forKey: rateKey)
        if savedRate > 0 {
            hourlyRate = savedRate
        }
    }

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
}
