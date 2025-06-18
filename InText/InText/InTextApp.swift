import SwiftUI

@main
struct InTextApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var themeService = AppThemeService()

    var body: some Scene {
        WindowGroup {
            AuthContainerView()
                .environmentObject(themeService)
                .preferredColorScheme(themeService.colorScheme)
        }
    }
}
