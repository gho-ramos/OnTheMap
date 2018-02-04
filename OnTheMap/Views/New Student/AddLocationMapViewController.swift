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

}
