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

//        AuthenticationClient.shared.authenticate(username: username!, password: password!) { (authentication, error) in
//
//        }
        completeLogin()
    }

    private func completeLogin() {
        let navigationTabController = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "NavigationTabBarController")
        present(navigationTabController, animated: true, completion: nil)
    }
}

extension ViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print("\(error)")
        case .cancelled:
            print("canceled")
        case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
            AuthenticationClient.shared.authenticate(with: token.authenticationToken) { (authentication, error) in

            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {

    }
}
