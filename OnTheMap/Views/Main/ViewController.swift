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
        if let username = usernameTextField.text, let password = passwordTextField.text {
            Loader.show(on: self)
            let user = UdacityAuthentication(username: username, password: password)
            AuthenticationClient.shared.login(with: user, success: { authentication in
                self.completeLogin(for: authentication)
            }, failure: { error in
                Loader.hide()
                Dialog.show(error: error)
            })
        }
    }

    @IBAction func signUp(_ sender: Any) {
        open(url: "https://www.udacity.com/account/auth#!/signup")
    }

    private func completeLogin(for authentication: AuthenticationResponse?) {
        if let auth = authentication, let acc = auth.account, let key = acc.key {
            AuthenticationClient.shared.getUserInformation(for: key, success: { response in
                Loader.hide()
                SessionManager.shared.user = response?.user
                self.completeLogin()
            }, failure: { error in
                Loader.hide()
                Dialog.show(error: error)
            })
        } else {
            Loader.hide()
            Dialog.show(message: "Sorry, we were not able to complete the authentication, try again later.",
                        title: "Login Failed")
        }
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
        let facebookAuthentication = FacebookAuthentication(token: token)
        AuthenticationClient.shared.login(with: facebookAuthentication, success: { authentication in
            self.completeLogin(for: authentication)
        }, failure: { error in
            Loader.hide()
            Dialog.show(error: error)
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
