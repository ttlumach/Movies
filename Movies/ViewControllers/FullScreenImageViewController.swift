//
//  FullScreenImageViewController.swift
//  Movies
//
//  Created by Macbook on 15.07.2024.
//

import UIKit
import ImageScrollView
import SnapKit
import Nuke

class FullScreenImageViewController: UIViewControllerWithSpinner {
    
    private var imageScrollView = ImageScrollView()
    private var image: UIImage?
    private let url: URL
    private var task: Task<(), Never>?
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tgr)

        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blurredView.frame = self.view.bounds
        view.addSubview(blurredView)
        
        blurredView.contentView.addSubview(imageScrollView)
        imageScrollView.addGestureRecognizer(tgr)
        imageScrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        imageScrollView.setup()
        imageScrollView.imageContentMode = .widthFill
        imageScrollView.initialOffset = .center
        
        getImage(url: url)
    }
    
    func getImage(url: URL) {
        startSpinner()
        task = Task(priority: .userInitiated) {
            do {
                let imagePipeline = ImagePipeline(configuration: .withDataCache)
                let image = try await imagePipeline.image(for: url)
                await MainActor.run { [weak self] in
                    self?.stopSpinner()
                    self?.image = image
                    self?.imageScrollView.display(image: image)
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.stopSpinner()
                    self?.displayErrorAlert(error: NetworkError.cantLoadImage)
                }
            }
        }
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        if image == nil {
            task?.cancel()
            self.dismiss(animated: true)
        }
        
        if (tap.state == .ended) {
            let point = tap.location(in: self.view)
            
            if !(CGRectContainsPoint(imageScrollView.zoomView?.frame ?? CGRect(), point)) { // check if tap is outside of the image
                self.dismiss(animated: true)
            }
        }      
    }
}
