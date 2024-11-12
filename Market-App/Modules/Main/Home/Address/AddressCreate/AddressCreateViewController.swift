//
//  AddressAddViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

import UIKit
import MapKit

protocol AddressCreateViewControllerProtocol: AnyObject {
    func updateAddressTable()
    func updateSelectedAddress(with address: String)
    func centerMap(on coordinate: CLLocationCoordinate2D)
    func showErrorMessage(message: String)
}

class AddressCreateViewController: UIViewController, MKMapViewDelegate {
    
    var presenter: AddressCreatePresenterProtocol!
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.addTarget(self, action: #selector(addressTextFieldDidChange), for: .editingChanged)
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = .marketLightGray
        textField.layer.borderWidth = 0.2
        textField.layer.cornerRadius = 20
        
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search district, street, etc.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height))
        
        let searchImage = UIImageView(
            frame: CGRect(x: 10, y: (leftPaddingView.frame.height - 20) / 2, width: 20, height: 20))
        searchImage.image = UIImage(systemName: "magnifyingglass")
        searchImage.preferredSymbolConfiguration = .init(pointSize: 14)
        searchImage.tintColor = .marketOrange
        searchImage.contentMode = .scaleAspectFit
        
        leftPaddingView.addSubview(searchImage)
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Use this location  ", for: .normal)
        button.backgroundColor = .marketOrange
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(continueWithAddress), for: .touchUpInside)
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
        view.backgroundColor = .white
        title = "Add News Address"
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
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        setupAddressTextFieldConstraints()
        setupMapViewConstraints()
        setupMapPinConstraints()
        setupSelectedAddressLabelConstraints()
        setupSuggestionsTableViewConstraints()
        setupAddressTextViewConstraints()
        setupSaveButtonConstraints()
    }
    
    private func setupAddressTextFieldConstraints() {
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(40)
        }
    }
    
    private func setupMapViewConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-128)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
    
    @objc private func continueWithAddress() {
        presenter.saveAddress()
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

extension AddressCreateViewController: UITableViewDataSource {
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

extension AddressCreateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = presenter.getAddress(at: indexPath.row)
        addressTextField.text = selectedAddress
        suggestionsTableView.isHidden = true
        presenter.getLocationFromAddressText(address: selectedAddress)
    }
}

extension AddressCreateViewController: AddressCreateViewControllerProtocol {
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

extension AddressCreateViewController: InfoPopUpShowable {
    func showErrorMessage(message: String) {
        showInfoPopUp(message: message) {}
    }
}

extension AddressCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
