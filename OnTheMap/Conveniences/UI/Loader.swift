//
//  Loader.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 26/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class Loader: NSObject {
    static var loaderView: UIView?

    private class func buildLoadingView(with frame: CGRect) -> UIView {
        let center = CGPoint(x: frame.midX, y: frame.midY)

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        activityIndicator.center = center
        activityIndicator.startAnimating()

        return activityIndicator
    }

    private class func buildOverlay(with frame: CGRect, dimBackground: Bool) -> UIView {
        let overlay = UIView(frame: frame)
        let loaderView = buildLoadingView(with: frame)
        overlay.addSubview(loaderView)
        if dimBackground {
            overlay.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        }
        return overlay
    }

    class func show(on viewController: UIViewController) {
        performUIUpdatesOnMain {
            loaderView = buildOverlay(with: viewController.view.frame, dimBackground: true)
            viewController.view.addSubview(loaderView!)
        }
    }

    class func hide() {
        performUIUpdatesOnMain {
            loaderView?.removeFromSuperview()
        }
    }
}
