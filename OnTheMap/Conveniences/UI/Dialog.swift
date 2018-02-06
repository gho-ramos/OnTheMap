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

    /// Create an alert controller with a message and a title, optionally it is possible to
    /// add a custom confirmation code after the user presses the "OK" button
    ///
    /// - Parameters:
    ///   - message: Message that will be shown on the alert box
    ///   - title: Title of the alert
    ///   - confirmation: Custom confirmation code
    /// - Returns: UIAlertController ready to be presented
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

    /// Get the current visible controller on the aplication
    ///
    /// - Parameter parentViewController: last view controller checked
    /// - Returns: The top view controller (or visible) at the moment
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

    /// Show an alert with a message and a custom code
    ///
    /// - Parameters:
    ///   - message: Message to be shown onto the alert dialog
    ///   - title: Title of the alert dialog
    ///   - confirmation: Custom confirmation code
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

    /// Show an alert with a message
    ///
    /// - Parameters:
    ///   - message: Message to be shown onto the alert dialog
    ///   - title: Title of the alert dialog
    class func show(message: String?, title: String?) {
        let alert = buildAlert(message: message, title: title)

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            let viewController = visibleViewController(from: rootViewController)
            performUIUpdatesOnMain {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }

    /// Show an alert with a message based on the error's localized description
    ///
    /// - Parameter error: Error object
    class func show(error: Error?) {
        self.show(message: error?.localizedDescription, title: "Error")
    }

}
