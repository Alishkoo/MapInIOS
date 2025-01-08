//
//  ViewController.swift
//  projectWithMap
//
//  Created by Alibek Baisholanov on 31.12.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController{
    
    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.delegate = self
        searchTextField.backgroundColor = .white
        searchTextField.placeholder = "Search"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
        
        setupUI()
    }
    
    
    private func setupUI(){
        view.addSubview(searchTextField)
        view.addSubview(mapView)
        
        //constraints to the textField
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        view.bringSubviewToFront(searchTextField)
        
        //constraints to the mapView
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
        let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
            
        case .denied:
            print("denied")
        case .notDetermined, .restricted:
            print("notdetermined")
        default:
            print("default")
        }
    }
    
    // MARK: Places Sheet
    private func presentPlacesSheet(places: [PlaceAnnotation]){
        
        guard let locationManager = locationManager,
              let userLocation = locationManager.location
        else {return}
        
        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController{
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTVC, animated: true)
        }
    }
    
    // MARK: show places with search
    private func findNearbyPlaces(by query: String){
        
        //clear all notations
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            
            guard let response = response, error == nil else {return}
            
            self.places = response.mapItems.map(PlaceAnnotation.init)
            self.places.forEach{ place in
                self.mapView.addAnnotation(place)
            }
            
            
            self.presentPlacesSheet(places: self.places)
        }
    }
    
}


//MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    private func clearAllSelections(){
        self.places = self.places.map { place in
            place.isSelected = false
            return place
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        //clear all selections
        clearAllSelections()
        
        guard let selectedAnnotation = annotation as? PlaceAnnotation else {return}
        
        let placeAnnotation = self.places.first(where: { $0.id == selectedAnnotation.id })
        placeAnnotation?.isSelected = true
        
        presentPlacesSheet(places: self.places)
        
    }
    
}


//MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let text = textField.text ?? ""
        if !text.isEmpty{
            textField.resignFirstResponder()
            
            //find nearby places
            findNearbyPlaces(by: text)
        }
        print(text)
        return true
    }
    
}

//MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

