//
//  LocationManager.swift
//  weather
//
//  Created by Jason Zheng on 3/3/23.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationDidUpdate(location: CLLocation)
    func locationFailedToUpdate(error: Error)
}

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.locationDidUpdate(location: location)
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationFailedToUpdate(error: error)
    }
}
