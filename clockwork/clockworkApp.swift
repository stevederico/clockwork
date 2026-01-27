//
//  clockworkApp.swift
//  clockwork
//
//  Created by Steve Derico on 1/16/26.
//

import SwiftUI
import AppKit
import Combine

@main
struct clockworkApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let timerManager = TimerManager()
    private let popover = NSPopover()
    private var statusItem: NSStatusItem?
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        if isAnotherInstanceRunning() {
            NSApp.terminate(nil)
            return
        }
        setupStatusItem()
        setupPopover()
        bindStatusIconUpdates()
    }

    private func isAnotherInstanceRunning() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications
        let instances = runningApps.filter { $0.bundleIdentifier == Bundle.main.bundleIdentifier }
        return instances.count > 1
    }

    private func setupStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem = item
        if let button = item.button {
            button.image = statusImage()
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
    }

    private func setupPopover() {
        popover.behavior = .applicationDefined
        popover.animates = true
        popover.contentViewController = NSHostingController(
            rootView: MenuBarView()
                .environmentObject(timerManager)
        )
    }

    private func bindStatusIconUpdates() {
        timerManager.$isPaused
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateStatusIcon()
            }
            .store(in: &cancellables)

        timerManager.$currentSession
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateStatusIcon()
            }
            .store(in: &cancellables)
    }

    @objc private func togglePopover(_ sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            showPopover(sender)
        }
    }

    private func showPopover(_ sender: Any?) {
        guard let button = statusItem?.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func updateStatusIcon() {
        statusItem?.button?.image = statusImage()
    }

    private func statusImage() -> NSImage {
        let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .light)
        let imageName: String
        if timerManager.isPaused {
            imageName = "pause.fill"
        } else if timerManager.isRunning {
            imageName = "dollarsign.circle.fill"
        } else {
            imageName = "clock"
        }
        let image = NSImage(systemSymbolName: imageName, accessibilityDescription: nil)!
        return image.withSymbolConfiguration(config)!
    }
}
