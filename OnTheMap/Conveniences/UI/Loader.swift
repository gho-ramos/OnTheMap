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
    class func show(on viewController: UIViewController) {
        let loadingImage = UIImageView(image: #imageLiteral(resourceName: "loading"))

        loaderView = UIView(frame: viewController.view.frame)
        loaderView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        loaderView?.addSubview(loadingImage)
        loadingImage.center = (loaderView?.center)!
        performUIUpdatesOnMain {
            viewController.view.addSubview(loaderView!)
        }
    }

    class func hide() {
        performUIUpdatesOnMain {
            loaderView?.removeFromSuperview()
        }
    }
}
