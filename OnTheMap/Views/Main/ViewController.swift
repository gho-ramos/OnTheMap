//
//  ViewController.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 17/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {

    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let accessToken = AccessToken.current {
            facebookLogin(with: accessToken.authenticationToken)
        }

        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        loginButton.delegate = self
        rootStackView.addArrangedSubview(loginButton)
        passwordTextField.textContentType = .password
    }

    @IBAction func login(_ sender: Any?) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        Loader.show(on: self)

        AuthenticationClient.shared.login(username: username!, password: password!,
        success: { (_) in
            Loader.hide()
            self.completeLogin()
        }, failure: { error in
            Loader.hide()
            Dialog.show(message: error?.localizedDescription, title: "Error")
        })
    }

    @IBAction func signUp(_ sender: Any) {
        open(url: "https://www.udacity.com/account/auth#!/signup")
    }

    private func completeLogin() {
        performUIUpdatesOnMain {
            let navigationTabController = UIStoryboard.init(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "NavigationTabBarController")
            self.present(navigationTabController, animated: true, completion: nil)
        }
    }
}

extension ViewController: LoginButtonDelegate {

    fileprivate func facebookLogin(with token: String) {
        Loader.show(on: self)
        AuthenticationClient.shared.login(with: token, success: { _ in
            Loader.hide()
            self.completeLogin()
        }, failure: { error in
            Loader.hide()
            Dialog.show(message: error?.localizedDescription, title: "Error")
        })
    }

    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            Loader.hide()
            print("\(error)")
        case .cancelled:
            print("canceled")
        case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
            self.facebookLogin(with: token.authenticationToken)
        }
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {}
}
