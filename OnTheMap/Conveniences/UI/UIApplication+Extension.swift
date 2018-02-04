//
//  UIApplication+Extension.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 04/02/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

extension UIApplication {
    func open(url: String?) {
        guard let url = url else { return }
        guard let builtUrl = URL(string: url) else { return }

        self.open(builtUrl)
    }
}
