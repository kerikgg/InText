//
//  InTextApp.swift
//  InText
//
//  Created by kerik on 08.05.2025.
//

import SwiftUI

@main
struct InTextApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RegistrationView()
        }
    }
}
