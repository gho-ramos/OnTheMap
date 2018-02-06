//
//  UIApplication+Extension.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 04/02/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

extension UIApplication {
    /// Test the parameter string as URL and try to open it
    ///
    /// - Parameter url: String of the desired url
    func open(url: String?) {
        guard let url = url else { return }
        guard let builtUrl = URL(string: url) else { return }

        self.open(builtUrl)
    }
}
