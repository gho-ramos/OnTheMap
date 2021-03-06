//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 03/02/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import MapKit

class AddLocationMapViewController: UIViewController {

    var mapItem: MKMapItem?
    var mapString: String?
    var mediaURL: String?

    let mapViewControllerDelegateHandler = MapViewControllerDelegateHandler()

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = mapViewControllerDelegateHandler
        placePin()
    }

    private func placePin() {
        if let item = mapItem {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: item.placemark.coordinate, span: span)
            mapView.addAnnotation(createAnnotation(for: item.placemark))
            mapView.setRegion(region, animated: true)
        }
    }

    private func createAnnotation(for mapItemPlaceMark: MKPlacemark) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItemPlaceMark.coordinate
        if let city = mapItemPlaceMark.locality, let state = mapItemPlaceMark.administrativeArea {
            annotation.title = "\(city), \(state)"
        }
        return annotation
    }

    // MARK: Actions
    @IBAction func saveUserLocation() {
        // The screen will only load if the mapItem object returns successfully
        // but to guarantee that we have some coordinate, i'm checking the optional
        // to avoid errors, posting empty coordinates to the server
        guard let coordinate = mapItem?.placemark.coordinate else { return }

        // Checking if the user is logged
        guard let user = DataManager.shared.user else { return }

        // Create the student object, with the information gathered until now

        let studentLocation = StudentLocation(objectId: nil, uniqueKey: user.key,
                                              firstName: user.firstName, lastName: user.lastName,
                                              mapString: mapString, mediaURL: mediaURL,
                                              latitude: coordinate.latitude, longitude: coordinate.longitude,
                                              createdAt: nil, updatedAt: nil)

        Loader.show(on: self)

        // Post the student object to the server and wait for a response to either return
        // to the last viewController on the tabBarController or warn the user that the request
        // failed.

        StudentInformationClient().saveStudent(studentLocation, success: { student in
            Loader.hide()
            if student != nil {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                Dialog.show(message: "Failed to save the location", title: "Error")
            }
        }, failure: { error in
            Loader.hide()
            Dialog.show(error: error)
        })
    }

}
