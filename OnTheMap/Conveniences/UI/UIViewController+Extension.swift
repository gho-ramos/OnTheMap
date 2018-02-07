//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Guilherme on 1/30/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

extension UIViewController {

    /// Generic instance method for the viewController
    ///
    /// - Parameters:
    ///   - storyboardName: Desired viewController's storyboard name
    ///   - identifier: ViewController's identifier
    /// - Returns: The viewController with the specified identifier
    class func instance(from storyboardName: String, identifier: String) -> Self {
        return genericStoryboardInstance(with: storyboardName, identifier: identifier)!
    }

    /// Get a generic viewController (type defined on execution) with an identifier
    /// from a named storyboard
    ///
    /// - Parameters:
    ///   - name: Name of the storyboard
    ///   - identifier: ViewController's identifier
    /// - Returns: Generic viewController (independent of the type)
    private class func genericStoryboardInstance<T>(with name: String, identifier: String) -> T? {
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: identifier
        )
        return controller as? T
    }

    /// Extend the open url from the uiapplication's extension to use it seamlessly on a viewController
    ///
    /// - Parameter url: String of the desired url
    func open(url: String?) {
        UIApplication.shared.open(url: url)
    }

    // MARK: Bar button actions

    /// Present the "Add Location" View Controller
    ///
    /// - Parameter sender: Any
    @IBAction func presentAddLocationViewController(_ sender: Any?) {
        if let navController = UIStoryboard(name: "New", bundle: nil)
            .instantiateInitialViewController() {
            present(navController, animated: true, completion: nil)
        }
    }

    /// Prompts the user if him/her really wants to exit the application
    /// if positive, it removes the user's session
    ///
    /// - Parameter sender: Any
    @IBAction func logout(_ sender: Any?) {
        Dialog.show(message: "Do you really wish to logout from the application?", title: "Wait!") {
            Loader.show(on: self)
            AuthenticationClient.shared.logout(success: { (_) in
                Loader.hide()
                performUIUpdatesOnMain {
                    SessionManager.shared.user = nil
                    if AccessToken.current != nil {
                        LoginManager().logOut()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }, failure: { (error) in
                Loader.hide()
                Dialog.show(message: error?.localizedDescription, title: "Failed to close session")
            })
        }
    }

}
