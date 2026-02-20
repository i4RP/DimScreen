import AppKit
import Combine

final class OverlayWindowController {
    private var overlayWindows: [NSWindow] = []
    private var cancellables = Set<AnyCancellable>()
    private let brightnessManager = BrightnessManager.shared

    init() {
        setupObservers()
        setupScreenChangeObserver()
    }

    private func setupObservers() {
        brightnessManager.$dimLevel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] level in
                self?.updateOverlayOpacity(level)
            }
            .store(in: &cancellables)

        brightnessManager.$isEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                if enabled {
                    self?.showOverlays()
                } else {
                    self?.hideOverlays()
                }
            }
            .store(in: &cancellables)
    }

    private func setupScreenChangeObserver() {
        NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.recreateOverlays()
            }
            .store(in: &cancellables)
    }

    private func createOverlays() {
        removeAllOverlays()
        for screen in NSScreen.screens {
            let window = makeOverlayWindow(for: screen)
            overlayWindows.append(window)
        }
    }

    private func makeOverlayWindow(for screen: NSScreen) -> NSWindow {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.backgroundColor = NSColor.black.withAlphaComponent(brightnessManager.dimLevel)
        window.isOpaque = false
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        window.hasShadow = false
        window.animationBehavior = .none
        return window
    }

    func showOverlays() {
        if overlayWindows.isEmpty {
            createOverlays()
        }
        for window in overlayWindows {
            window.orderFrontRegardless()
        }
    }

    func hideOverlays() {
        for window in overlayWindows {
            window.orderOut(nil)
        }
    }

    private func updateOverlayOpacity(_ opacity: Double) {
        for window in overlayWindows {
            window.backgroundColor = NSColor.black.withAlphaComponent(opacity)
        }
    }

    private func removeAllOverlays() {
        for window in overlayWindows {
            window.orderOut(nil)
        }
        overlayWindows.removeAll()
    }

    private func recreateOverlays() {
        let wasVisible = overlayWindows.first?.isVisible == true
        createOverlays()
        if wasVisible && brightnessManager.isEnabled {
            showOverlays()
        }
    }
}
