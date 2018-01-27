//
//  UIViewController+UI.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 24/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

extension UIViewController {

    func configureRootUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logout))
        navigationItem.title = "On the Map"
        configureRightButtons()
    }

    fileprivate func configureRightButtons() {
        let buttons = [
            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: nil)
        ]
        navigationItem.setRightBarButtonItems(buttons, animated: false)
    }

    fileprivate func facebookLogout() {
        let loginManager = LoginManager()
        loginManager.logOut()
        Loader.hide()
        dismiss(animated: true, completion: nil)
    }

    fileprivate func udacityLogout() {
        AuthenticationClient.shared.logout(success: { authentication in
            Loader.hide()
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }, failure: { error in
            Loader.hide()
            Dialog.show(message: error?.localizedDescription, title: "Failed to end session")
        })
    }

    @objc @IBAction func logout(sender: Any) {
        Loader.show(on: self)
        if AccessToken.current != nil {
            facebookLogout()
        } else {
            udacityLogout()
        }
    }
}
