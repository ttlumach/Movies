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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = LocalizedString.settings
        setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(languageLabel)
        languageLabel.text = LocalizedString.language
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
            make.trailing.equalTo(view.snp.trailing).offset(-50)
        }
    }
    
    @objc private func chooseLanguageButtonPressed() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
}
