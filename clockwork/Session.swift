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
        let hours = duration / 3600.0
        return String(format: "%.2f hrs", hours)
    }

    var formattedEarnings: String {
        return String(format: "$%.2f", earnings)
    }

    var formattedStartTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d, h:mm a"
        return formatter.string(from: startTime)
    }

    var formattedEndTime: String? {
        guard let end = endTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: end)
    }
}
