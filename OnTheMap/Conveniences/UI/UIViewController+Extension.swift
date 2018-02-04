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

    class func instance(from storyboardName: String, identifier: String) -> Self {
        return genericStoryboardInstance(with: storyboardName, identifier: identifier)!
    }

    private class func genericStoryboardInstance<T>(with name: String, identifier: String) -> T? {
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: identifier
        )
        return controller as? T
    }

    func open(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        UIApplication.shared.open(url)
    }

    // MARK: Bar button actions
    @IBAction func presentAddLocationViewController(_ sender: Any?) {
        if let navController = UIStoryboard(name: "New", bundle: nil)
            .instantiateInitialViewController() {
            present(navController, animated: true, completion: nil)
        }
    }

    @IBAction func logout(_ sender: Any?) {
        Dialog.show(message: "Do you really wish to logout from the application?", title: "Wait!") {
            Loader.show(on: self)
            AuthenticationClient.shared.logout(success: { (_) in
                Loader.hide()
                performUIUpdatesOnMain {
                    if AccessToken.current != nil {
                        LoginManager().logOut()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }, failure: { (error) in
                Dialog.show(message: error?.localizedDescription, title: "Failed to close session")
            })
        }
    }

}
