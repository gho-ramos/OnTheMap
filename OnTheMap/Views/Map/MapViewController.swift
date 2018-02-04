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
    let mapViewControllerDelegateHandler = MapViewControllerDelegateHandler()

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = mapViewControllerDelegateHandler
        loadStudents()
        configureUI()
    }

    func configureUI() {
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(reloadStudents))
        navigationItem.rightBarButtonItems?.append(refreshButton)
    }

    @objc func reloadStudents() {
        loadStudents(shouldForceReload: true)
    }

    func loadStudents(shouldForceReload: Bool = true) {
        Loader.show(on: self)
        if shouldForceReload || StudentInformationClient.shared.all.count == 0 {
            StudentInformationClient.shared.getStudents(with: [:], success: { _ in
                Loader.hide()
                performUIUpdatesOnMain {
                    self.populateStudentsMap()
                }
            }, failure: { error in
                Loader.hide()
                Dialog.show(message: error?.localizedDescription, title: "Failed to download the list of students")
            })
        } else {
            Loader.hide()
            populateStudentsMap()
        }
    }

    func populateStudentsMap() {
        var annotations = [MKPointAnnotation]()

        for student in StudentInformationClient.shared.all {
            if let annotation = student.studentAnnotationPoint() {
                annotations.append(annotation)
            }
        }

        mapView.addAnnotations(annotations)
    }
}
