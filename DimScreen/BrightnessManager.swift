import Foundation
import Combine

final class BrightnessManager: ObservableObject {
    static let shared = BrightnessManager()

    @Published var dimLevel: Double {
        didSet {
            UserDefaults.standard.set(dimLevel, forKey: "dimLevel")
        }
    }

    @Published var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: "isEnabled")
        }
    }

    private init() {
        let savedLevel = UserDefaults.standard.object(forKey: "dimLevel") as? Double ?? 0.3
        let savedEnabled = UserDefaults.standard.object(forKey: "isEnabled") as? Bool ?? true
        self.dimLevel = savedLevel
        self.isEnabled = savedEnabled
    }
}
