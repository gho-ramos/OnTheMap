//
//  UIViewController+UI.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 24/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

extension UIViewController {

    func configureRootUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
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

    @objc func logout() {
        AuthenticationClient.shared.logout { (result, error) in
            //TODO: logout user (pop vc)
        }
    }
    
}
