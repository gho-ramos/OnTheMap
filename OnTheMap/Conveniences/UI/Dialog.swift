//
//  Dialog.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 26/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class Dialog: NSObject {

    class func show(message: String?, title: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            performUIUpdatesOnMain {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}
