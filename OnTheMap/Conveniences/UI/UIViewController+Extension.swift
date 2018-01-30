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

    // MARK: Logout config

    func configureLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutButton
    }

    @objc func logout() {
        Dialog.show(message: "Do you really wish to logout from the application?", title: "Wait!") {
            AuthenticationClient.shared.logout(success: { (_) in
                if AccessToken.current != nil {
                    LoginManager().logOut()
                }
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            }, failure: { (error) in
                Dialog.show(message: error?.localizedDescription, title: "Failed to close session")
            })
        }
    }

}
