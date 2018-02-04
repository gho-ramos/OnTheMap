//
//  Dialog.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 26/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class Dialog: NSObject {

    typealias Confirmation = (() -> Void)

    private class func buildAlert(message: String?, title: String?, _ confirmation: Confirmation? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action: UIAlertAction!
        if let confirmation = confirmation {
            action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                confirmation()
            })
        } else {
            action = UIAlertAction(title: "OK", style: .default)
        }
        alert.addAction(action)
        return alert
    }

    private class func visibleViewController(from parentViewController: UIViewController) -> UIViewController {
        guard let viewController = parentViewController.presentedViewController else {
            return parentViewController
        }

        if let navigationController = viewController as? UINavigationController,
            let topViewController = navigationController.topViewController {
            return visibleViewController(from: topViewController)
        }

        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return visibleViewController(from: selectedViewController)
        }

        return visibleViewController(from: viewController)
    }

    class func show(message: String?, title: String?, _ confirmation: Confirmation?) {
        let alert = buildAlert(message: message, title: title, confirmation)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            let viewController = visibleViewController(from: rootViewController)
            performUIUpdatesOnMain {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }

    class func show(message: String?, title: String?) {
        let alert = buildAlert(message: message, title: title)

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            let viewController = visibleViewController(from: rootViewController)
            performUIUpdatesOnMain {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }

}
