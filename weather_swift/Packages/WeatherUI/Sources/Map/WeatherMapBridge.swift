//
//  WeatherMapBridge.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/23.
//

import SwiftUI
import MapKit
import WeatherCore

struct WeatherMapBridge: UIViewRepresentable {
    let currentData: WeatherData
    
    private var center: CLLocationCoordinate2D {
        let centerCoord = currentData.coord
        return .init(latitude: centerCoord.lat, longitude: centerCoord.lon)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        mapView.setRegion(region, animated: false)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let targetCenter = CLLocationCoordinate2D(
            latitude: currentData.coord.lat,
            longitude: currentData.coord.lon
        )
        let distance = abs(uiView.centerCoordinate.latitude - targetCenter.latitude)
        if distance > 0.001 {
            let region = MKCoordinateRegion(
                center: targetCenter,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
            uiView.setRegion(region, animated: true)
        }
        let existingSearchPin = uiView.annotations.compactMap { $0 as? WeatherAnnotation }.first { !$0.isHome }
        let needsNewPin = existingSearchPin == nil ||
        abs(existingSearchPin!.coordinate.latitude - currentData.coord.lat) > 0.0001
        
        if needsNewPin {
            let oldSearchPins = uiView.annotations.compactMap { $0 as? WeatherAnnotation }.filter { !$0.isHome }
            uiView.removeAnnotations(oldSearchPins)
            let anno = WeatherAnnotation(data: currentData, isHome: false)
            uiView.addAnnotation(anno)
            
            uiView.selectAnnotation(anno, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    private func makeSearchAnnotation() -> WeatherAnnotation {
        WeatherAnnotation(data: currentData, isHome: false)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let weatherAnno = annotation as? WeatherAnnotation else { return nil }
            
            let identifier = "WeatherPin-\(weatherAnno.isHome)"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: weatherAnno, reuseIdentifier: identifier)
            } else {
                view?.annotation = weatherAnno
            }
            view?.markerTintColor = weatherAnno.isHome ? .systemBlue : .systemOrange
            if weatherAnno.isHome {
                view?.canShowCallout = false
                view?.rightCalloutAccessoryView = nil
                view?.markerTintColor = .systemBlue
            } else {
                view?.canShowCallout = true
                view?.markerTintColor = .systemOrange
            }
            return view
        }
        
    }
}
