//
//  ViewController.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 17/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {

    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        rootStackView.addArrangedSubview(loginButton)
        passwordTextField.textContentType = .password

    }

    @IBAction func login(_ sender: Any?) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        AuthenticationNetwork.shared.postSessionForUdacity(username: username!, password: password!) { (authentication, error) in

        }
    }
}

extension ViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {

    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {

    }
}
