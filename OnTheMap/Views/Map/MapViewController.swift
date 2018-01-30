//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 24/01/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let pinIdentifier = "studentPin"

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudents()
        configureUI()
    }

    func configureUI() {
        configureLogoutButton()
        configureUIButtons()
    }

    func configureUIButtons() {
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(reloadStudents))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }

    @objc func reloadStudents() {
        loadStudents(shouldForceReload: true)
    }

    func loadStudents(shouldForceReload: Bool = true) {
        Loader.show(on: self)
        if shouldForceReload || StudentInformationClient.shared.all == nil {
            StudentInformationClient.shared.getStudents(with: [:], success: { _ in
                Loader.hide()
                performUIUpdatesOnMain {
                    self.populateStudentsMap()
                }
            }, failure: { error in
                Loader.hide()
                Dialog.show(message: error?.localizedDescription, title: "Failed to fetch students")
            })
        } else {
            Loader.hide()
            populateStudentsMap()
        }
    }

    func populateStudentsMap() {
        var annotations = [MKPointAnnotation]()
        for student in StudentInformationClient.shared.all! {
            if let annotation = student.studentAnnotationPoint() {
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pin = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) else {

            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            return pin
        }

        pin.annotation = annotation
        return pin
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let url = view.annotation?.subtitle else {
            return
        }
        open(url: url!)
    }

}
