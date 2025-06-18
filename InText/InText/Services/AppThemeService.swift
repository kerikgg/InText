import SwiftUI

final class AppThemeService: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
}
