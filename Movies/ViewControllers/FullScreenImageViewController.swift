//
//  FullScreenImageViewController.swift
//  Movies
//
//  Created by Macbook on 15.07.2024.
//

import UIKit
import ImageScrollView
import SnapKit

class FullScreenImageViewController: UIViewController {
    
    private var imageScrollView = ImageScrollView()
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tgr)
        view.backgroundColor = .clear
        
        view.addSubview(imageScrollView)
        imageScrollView.addGestureRecognizer(tgr)
        imageScrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        imageScrollView.setup()
        imageScrollView.imageContentMode = .aspectFit
        imageScrollView.initialOffset = .center
        imageScrollView.display(image: image ?? UIImage())
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        if (tap.state == .ended) {
            let point = tap.location(in: self.view)
            
            if !(CGRectContainsPoint(imageScrollView.zoomView?.frame ?? CGRect(), point)) { // check if tap is outside of the image
                self.dismiss(animated: true)
            }
        }      
    }
}
