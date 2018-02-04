//
//  MapViewControllerDelegateHandler.swift
//  OnTheMap
//
//  Created by Guilherme Ramos on 04/02/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import MapKit

class MapViewControllerDelegateHandler: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinIdentifier = "pin"
        guard let pin = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier)
            as? MKPinAnnotationView else {

                let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
                pin.canShowCallout = true
                pin.pinTintColor = .red
                pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

                return pin
        }

        pin.annotation = annotation
        return pin
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let url = view.annotation?.subtitle as? String else {
            return
        }
        UIApplication.shared.open(url: url)
    }
}
