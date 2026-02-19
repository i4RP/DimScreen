import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var overlayController: OverlayWindowController!

    func applicationDidFinishLaunching(_ notification: Notification) {
        overlayController = OverlayWindowController()
        setupStatusItem()
        setupPopover()

        if BrightnessManager.shared.isEnabled {
            overlayController.showOverlays()
        }
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "sun.min.fill",
                accessibilityDescription: "DimScreen"
            )
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    private func setupPopover() {
        let contentView = PopoverContentView()
            .environmentObject(BrightnessManager.shared)

        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 180)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
