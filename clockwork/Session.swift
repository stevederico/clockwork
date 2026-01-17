//
//  Session.swift
//  clockwork
//

import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    var startTime: Date
    var endTime: Date?
    var totalPausedDuration: TimeInterval
    var hourlyRate: Double

    init(startTime: Date = Date(), hourlyRate: Double) {
        self.id = UUID()
        self.startTime = startTime
        self.endTime = nil
        self.totalPausedDuration = 0
        self.hourlyRate = hourlyRate
    }

    var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime) - totalPausedDuration
    }

    var earnings: Double {
        return (duration / 3600.0) * hourlyRate
    }

    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var formattedEarnings: String {
        return String(format: "$%.2f", earnings)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
}
