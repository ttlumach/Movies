//
//  SettingsViewController.swift
//  Movies
//
//  Created by Macbook on 24.07.2024.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private var languageLabel = UILabel()
    private var chooseLanguageButton = UIButton(configuration: .borderedTinted())
    
    private var darkModeLabel = UILabel()
    private var darkModeSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        title = LocalizedString.settings
        setupUI()
    }
    
    private func setupUI() {
        // language
        self.view.addSubview(languageLabel)
        languageLabel.text = LocalizedString.language
        languageLabel.textColor = .primaryText
        languageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.leading.equalToSuperview().offset(30)
        }
        
        let code = Locale.current.languageCode ?? "en"
        let languageName = (Locale.current as NSLocale).displayName(forKey: .identifier, value: code)
        chooseLanguageButton.setTitle( (languageName ?? code), for: .normal)
        chooseLanguageButton.addTarget(self, action: #selector(chooseLanguageButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(chooseLanguageButton)
        chooseLanguageButton.snp.makeConstraints { make in
            make.centerY.equalTo(languageLabel.snp.centerY)
            make.trailing.equalTo(view).offset(-50)
        }
        
        // dark mode
        darkModeLabel.text = LocalizedString.darkMode
        darkModeLabel.textColor = .primaryText
        self.view.addSubview(darkModeLabel)
        darkModeLabel.snp.makeConstraints { make in
            make.top.equalTo(languageLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(30)
        }
        
        self.view.addSubview(darkModeSwitch)
        darkModeSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(darkModeLabel.snp.centerY)
            make.centerX.equalTo(chooseLanguageButton)
        }
        darkModeSwitch.isOn = isInDarkMode()
        darkModeSwitch.addTarget(self, action: #selector(toggleDarkMode), for: .valueChanged)
    }
    
    @objc private func chooseLanguageButtonPressed() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    @objc private func toggleDarkMode() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        if darkModeSwitch.isOn {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    private func isInDarkMode() -> Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let mode = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        return mode == .dark
    }
}
