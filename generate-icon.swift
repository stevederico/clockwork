#!/usr/bin/swift

import Cocoa

let backgroundColor = NSColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 1.0)
let goldColor = NSColor(red: 0.85, green: 0.70, blue: 0.35, alpha: 1.0)

func generateIcon(pixelSize: Int) -> Data? {
    let size = NSSize(width: pixelSize, height: pixelSize)

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixelSize,
        pixelsHigh: pixelSize,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!

    rep.size = size

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

    let rect = NSRect(x: 0, y: 0, width: pixelSize, height: pixelSize)

    // Background circle
    let bgPath = NSBezierPath(ovalIn: rect.insetBy(dx: CGFloat(pixelSize) * 0.02, dy: CGFloat(pixelSize) * 0.02))
    backgroundColor.setFill()
    bgPath.fill()

    // Gold border
    let borderPath = NSBezierPath(ovalIn: rect.insetBy(dx: CGFloat(pixelSize) * 0.06, dy: CGFloat(pixelSize) * 0.06))
    goldColor.setStroke()
    borderPath.lineWidth = CGFloat(pixelSize) * 0.025
    borderPath.stroke()

    // Gold clock symbol
    let config = NSImage.SymbolConfiguration(pointSize: CGFloat(pixelSize) * 0.45, weight: .medium)
        .applying(NSImage.SymbolConfiguration(paletteColors: [goldColor]))
    if let symbolImage = NSImage(systemSymbolName: "clock.fill", accessibilityDescription: nil)?.withSymbolConfiguration(config) {
        let symbolSize = symbolImage.size
        let symbolRect = NSRect(
            x: (CGFloat(pixelSize) - symbolSize.width) / 2,
            y: (CGFloat(pixelSize) - symbolSize.height) / 2,
            width: symbolSize.width,
            height: symbolSize.height
        )
        symbolImage.draw(in: symbolRect, from: .zero, operation: .sourceOver, fraction: 1.0)
    }

    NSGraphicsContext.restoreGraphicsState()

    return rep.representation(using: .png, properties: [:])
}

func saveIcon(data: Data, filename: String) {
    let url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("clockwork/Assets.xcassets/AppIcon.appiconset")
        .appendingPathComponent(filename)

    do {
        try data.write(to: url)
        print("Created \(filename)")
    } catch {
        print("Error saving \(filename): \(error)")
    }
}

// Correct pixel sizes for macOS app icons
let sizes: [(pixels: Int, filename: String)] = [
    (16, "icon_16x16.png"),
    (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"),
    (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"),
    (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"),
    (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"),
    (1024, "icon_512x512@2x.png"),
]

print("Generating icons...")
for item in sizes {
    if let data = generateIcon(pixelSize: item.pixels) {
        saveIcon(data: data, filename: item.filename)
    }
}
print("Done!")
