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
    private var viewModel: SettingsViewModelProtocol = SettingsViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        title = viewModel.title
        
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
        
        chooseLanguageButton.setTitle(viewModel.userLanguage, for: .normal)
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
        darkModeSwitch.isOn = viewModel.isInDarkMode()
        darkModeSwitch.addTarget(self, action: #selector(toggleDarkMode), for: .valueChanged)
    }
    
    @objc private func chooseLanguageButtonPressed() {
        viewModel.chooseLanguage()
    }
    
    @objc private func toggleDarkMode() {
        viewModel.toggleDarkMode()
    }
}
