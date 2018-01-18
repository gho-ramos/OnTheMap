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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])

        rootStackView.addArrangedSubview(loginButton)

        StudentInformationNetwork.shared.getStudentLocations { (students, error) in
            if error != nil {
                print("\(String(describing: error))")
            } else {
                print(students?.description ?? "")
            }
        }
    }
}

extension ViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {

    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {

    }
}
