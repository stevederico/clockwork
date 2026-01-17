//
//  clockworkApp.swift
//  clockwork
//
//  Created by Steve Derico on 1/16/26.
//

import SwiftUI

@main
struct clockworkApp: App {
    @StateObject private var timerManager = TimerManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(timerManager)
        } label: {
            Image(nsImage: {
                let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .bold)
                let image = NSImage(systemSymbolName: timerManager.currentSession != nil ? "dollarsign.circle.fill" : "clock", accessibilityDescription: nil)!
                return image.withSymbolConfiguration(config)!
            }())
        }
        .menuBarExtraStyle(.window)
    }
}
