//
//  SettingsViewControllerViewModel.swift
//  Movies
//
//  Created by Macbook on 24.07.2024.
//

import UIKit

protocol SettingsViewModelProtocol: AnyObject {
    var title: String { get }
    var userLanguage: String { get }
    func isInDarkMode() -> Bool
    func toggleDarkMode()
    func chooseLanguage()
}

class SettingsViewControllerViewModel: SettingsViewModelProtocol {
    
    private(set) var title = LocalizedString.settings
    
    var userLanguage: String {
        let code = Locale.current.languageCode ?? "en"
        return (Locale.current as NSLocale).displayName(forKey: .identifier, value: code) ?? code
    }
    
    func isInDarkMode() -> Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let mode = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        return mode == .dark
    }
    
    func toggleDarkMode() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        if isInDarkMode() {
            window?.overrideUserInterfaceStyle = .light
        } else {
            window?.overrideUserInterfaceStyle = .dark
        }
    }
    
    func chooseLanguage() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
