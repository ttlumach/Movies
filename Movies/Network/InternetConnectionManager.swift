//
//  InternetConnectionManager.swift
//  Movies
//
//  Created by Macbook on 16.07.2024.
//

import UIKit
import Alamofire

class InternetConnectionManager {
    static let shared = InternetConnectionManager()
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    private init() {}
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            switch status {
            case .reachable(_):
                break
            case .notReachable, .unknown:
                self?.showNoInternetAlert()
                break
            }
        })
    }
    
    private func showNoInternetAlert() {
        let alertController = UIAlertController(title: "Warning!",
                                                message: NetworkError.noInternet.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        let controller = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last?
            .rootViewController
        
        if let visibleViewController = controller {
            visibleViewController.present(alertController, animated: true)
        }
    }
}
