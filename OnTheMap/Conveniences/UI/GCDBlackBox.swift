//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Guilherme on 1/24/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
