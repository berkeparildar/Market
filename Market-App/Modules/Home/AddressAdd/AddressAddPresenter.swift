//
//  AddressAddPresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

import CoreLocation
import MapKit

protocol AddressAddPresenterProtocol {
    func getAddressCount() -> Int
    func getAddress(at index: Int) -> String
    func getAddressTextFromLocation(location: CLLocation)
    func getLocationFromAddressText(address: String)
    func setupMap()
    func performAddressSearch(query: String)
    func saveAddress(addressName: String)
}

final class AddressAddPresenter: NSObject, AddressAddPresenterProtocol, MKLocalSearchCompleterDelegate{
    
    var completer = MKLocalSearchCompleter()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var addressSuggestions: [MKLocalSearchCompletion] = []
    
    unowned var view: AddressAddViewControllerProtocol!
    private let interactor: AddressAddInteractorProtocol
    private let router: AddressAddRouterProtocol
    
    private var addressText: String?
    private var addressLocation: CLLocation?
    
    init(view: AddressAddViewControllerProtocol,
         interactor: AddressAddInteractorProtocol,
         router: AddressAddRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func setupMap() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let userLocation = locationManager.location?.coordinate {
            view.centerMap(on: userLocation)
        }
    }
    
    func saveAddress(addressName: String) {
        guard let addressText = addressText else {
            view.showErrorMessage(message: "Please select an address.")
            return
        }
        guard let addressLocation = addressLocation else {
            view.showErrorMessage(message: "Please select an address.")
            return
        }
        interactor.addNewAddress(addressText: addressText, adressName: addressName, latitude: addressLocation.coordinate.latitude, longitude: addressLocation.coordinate.longitude)
    }
    
    func performAddressSearch(query: String) {
        completer.queryFragment = query
    }
    
    func getAddressCount() -> Int {
        return addressSuggestions.count
    }
    
    func getAddress(at index: Int) -> String {
        let suggestion = addressSuggestions[index]
        return "\(suggestion.title) \(suggestion.subtitle)"
    }
    
    func getAddressTextFromLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self, let placemark = placemarks?.first else { return }
            let address = [placemark.name].compactMap { $0 }.joined(separator: ", ")
            self.addressLocation = location
            self.addressText = address
            self.view.updateSelectedAddress(with: address)
        }
    }
    
    func getLocationFromAddressText(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let self = self, let location = placemarks?.first?.location else { return }
            self.addressLocation = location
            self.addressText = address
            self.view.centerMap(on: location.coordinate)
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        addressSuggestions = completer.results
        view.updateAddressTable()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        view.updateAddressTable()
    }
}

extension AddressAddPresenter: AddressAddInteractorOutput {
    func addnewAddressOutput(error: (any Error)?) {
        if let error = error {
            view.showErrorMessage(message: error.localizedDescription)
        } else {
            router.navigate(to: .addressList)
        }
    }
}
