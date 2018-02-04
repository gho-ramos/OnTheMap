//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 03/02/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import MapKit

class AddLocationViewController: UIViewController {

    let kShowAddLocationMapSegueIdentifier = "showAddLocationMap"

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!

    class func instance() -> Self {
        return instance(from: "New", identifier: String(describing: self.self))
    }

    private func searchLocation() {
        Loader.show(on: self)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationTextField.text
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            Loader.hide()

            guard error == nil else {
                Dialog.show(message: error?.localizedDescription, title: "Failed to find location")
                return
            }

            guard let response = response else {
                return
            }

            self.performSegue(withIdentifier: self.kShowAddLocationMapSegueIdentifier, sender: response.mapItems)
        }
    }

    // MARK: Actions

    @IBAction func dismissAction(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func findLocationAction(_ sender: Any?) {
        searchLocation()
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowAddLocationMapSegueIdentifier,
            let addLocationMapViewController = segue.destination as? AddLocationMapViewController {
            if let mapItem = (sender as? [MKMapItem])?.first {
                addLocationMapViewController.mapItem = mapItem
            }
        }
    }
}
