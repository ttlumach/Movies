//
//  ViewController+Extensions.swift
//  Movies
//
//  Created by Macbook on 15.07.2024.
//

import UIKit

extension UIViewController {
    func displayAlert(title: String, message: String, actions: [UIAlertAction]? = nil, prefrerredStyle: UIAlertController.Style = .alert) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: prefrerredStyle)
      actions?.forEach { action in
        alertController.addAction(action)
      }
      present(alertController, animated: true)
    }
}
