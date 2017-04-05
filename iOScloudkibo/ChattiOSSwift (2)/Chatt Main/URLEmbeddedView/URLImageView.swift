//
//  URLImageView.swift
//  URLEmbeddedView
//
//  Created by Taiki Suzuki on 2016/03/07.
//
//

import UIKit
//import MisterFusion

final class URLImageView: UIImageView {
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var uuidString: String?
    var activityViewHidden: Bool = false
    var stopTaskWhenCancel = false
    
    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        activityView.hidesWhenStopped = true
        addLayoutSubview(activityView, andConstraints:
            activityView.width |==| 30,
            activityView.height |==| 30,
            activityView.centerX,
            activityView.centerY
        )
    }
    
    func loadImage(urlString: String, completion: ((UIImage?, Error?) -> Void)? = nil) {
        cancelLoadImage()
        if !activityViewHidden {
            activityView.startAnimating()
        }
        uuidString = OGImageProvider.shared.loadImage(urlString: urlString) { [weak self] image, error in
            DispatchQueue.main.async {
                if self?.activityViewHidden == false {
                    self?.activityView.stopAnimating()
                }
                if let error = error {
                    self?.image = nil
                    completion?(nil, error)
                    return
                }
                self?.image = image
                completion?(image, nil)
            }
        }
    }
    
    func cancelLoadImage() {
        if !activityViewHidden {
            activityView.stopAnimating()
        }
        guard let uuidString = uuidString else { return }
        OGImageProvider.shared.cancelLoad(uuidString, stopTask: stopTaskWhenCancel)
    }
}

