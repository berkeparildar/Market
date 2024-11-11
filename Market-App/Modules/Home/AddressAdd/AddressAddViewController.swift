//
//  AddressAddViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

import UIKit
import MapKit

protocol AddressAddViewControllerProtocol: AnyObject {
    func updateAddressTable()
    func updateSelectedAddress(with address: String)
    func centerMap(on coordinate: CLLocationCoordinate2D)
    func showErrorMessage(message: String)
}

class AddressAddViewController: UIViewController, MKMapViewDelegate {
    
    var presenter: AddressAddPresenterProtocol!
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.marketOrange.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 16
        textField.placeholder = "Enter your address."
        textField.delegate = self
        textField.addTarget(self, action: #selector(addressTextFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var addressNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Enter name (e.g., Home, Work)"
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.layer.borderColor = UIColor.marketOrange.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 16
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Save Address  ", for: .normal)
        button.backgroundColor = .marketOrange
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveAddress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 16
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var mapPin: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin"))
        imageView.tintColor = .marketOrange
        imageView.preferredSymbolConfiguration = .init(pointSize: 30)
        return imageView
    }()
    
    private lazy var selectedAddressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var addressTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.marketOrange.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var suggestionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        mapView.delegate = self
        setupViews()
        setupConstraints()
        presenter.setupMap()
    }
    
    private func setupViews() {
        view.addSubview(addressTextField)
        view.addSubview(mapView)
        mapView.addSubview(mapPin)
        mapView.addSubview(addressTextView)
        addressTextView.addSubview(selectedAddressLabel)
        view.addSubview(suggestionsTableView)
        view.addSubview(addressNameTextField)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        setupAddressTextFieldConstraints()
        setupMapViewConstraints()
        setupMapPinConstraints()
        setupSelectedAddressLabelConstraints()
        setupSuggestionsTableViewConstraints()
        setupAddressTextViewConstraints()
        setupAddressNameTextFieldConstraints()
        setupSaveButtonConstraints()
    }
    
    private func setupAddressTextFieldConstraints() {
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(addressNameTextField.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setupMapViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-64)
        }
    }
    
    private func setupMapPinConstraints() {
        mapPin.snp.makeConstraints { make in
            make.centerX.equalTo(mapView.snp.centerX)
            make.centerY.equalTo(mapView.snp.centerY)
        }
    }
    
    private func setupAddressTextViewConstraints() {
        addressTextView.snp.makeConstraints { make in
            make.bottom.equalTo(mapPin.snp.top).offset(-16)
            make.height.equalTo(48)
            make.centerX.equalTo(mapPin.snp.centerX)
        }
    }
    
    private func setupSelectedAddressLabelConstraints() {
        selectedAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTextView.snp.top).offset(10)
            make.leading.equalTo(addressTextView.snp.leading).offset(10)
            make.trailing.equalTo(addressTextView.snp.trailing).offset(-10)
            make.bottom.equalTo(addressTextView.snp.bottom).offset(-10)
        }
    }
    
    private func setupSuggestionsTableViewConstraints() {
        suggestionsTableView.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom)
            make.leading.equalTo(addressTextField)
            make.trailing.equalTo(addressTextField)
            make.height.equalTo(160)
        }
    }
    
    private func setupAddressNameTextFieldConstraints() {
        addressNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setupSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    @objc private func addressTextFieldDidChange() {
        guard let address = addressTextField.text, !address.isEmpty else {
            suggestionsTableView.isHidden = true
            return
        }
        presenter.performAddressSearch(query: address)
    }
    
    @objc private func saveAddress() {
        guard let addressName = addressNameTextField.text, !addressName.isEmpty else {
            showErrorMessage(message: "Please enter an address name.")
            return
        }
        print("Saving address with name: \(addressName)")
        presenter.saveAddress(addressName: addressName)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        addressTextField.text = ""
        
        presenter.getAddressTextFromLocation(location: location)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        self.updateSelectedAddress(with: "Loading...")
        suggestionsTableView.isHidden = true
    }
}

extension AddressAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(presenter.getAddressCount())
        return presenter.getAddressCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = presenter.getAddress(at: indexPath.row)
        return cell
    }
}

extension AddressAddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = presenter.getAddress(at: indexPath.row)
        addressTextField.text = selectedAddress
        suggestionsTableView.isHidden = true
        presenter.getLocationFromAddressText(address: selectedAddress)
    }
}

extension AddressAddViewController: AddressAddViewControllerProtocol {
    func updateAddressTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.suggestionsTableView.isHidden = presenter.getAddressCount() == 0
            self.suggestionsTableView.reloadData()
        }
    }
    
    func updateSelectedAddress(with address: String) {
        selectedAddressLabel.text = address
    }
    
    func centerMap(on coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}

extension AddressAddViewController: InfoPopUpShowable {
    func showErrorMessage(message: String) {
        showInfoPopUp(message: message) {}
    }
}

extension AddressAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
