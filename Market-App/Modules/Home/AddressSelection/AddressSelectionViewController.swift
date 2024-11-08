//
//  AddressSelectionViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 8.11.2024.
//

import UIKit

protocol AddressSelectionViewControllerProtocol: AnyObject {
    func reloadTableView()
    func showErrorMessage(message: String)
}

class AddressSelectionViewController: UIViewController {
    
    var presenter: AddressSelectionPresenterProtocol!
    private let addAddressCellIdentifier = "AddAddressCell"
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AddressCell.self, forCellReuseIdentifier: "AddressCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddAddressCell")
        tableView.tableFooterView = UIView() // Removes empty rows
        return tableView
    }()
    
    private let noAddressesLabel: UILabel = {
        let label = UILabel()
        label.text = "No Addresses Saved"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Select Address"
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
        presenter.getAddressInfo()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(noAddressesLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noAddressesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noAddressesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAddressesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


extension AddressSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let addressCount = presenter.getAddressCount()
        noAddressesLabel.isHidden = addressCount > 0
        return addressCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == presenter.getAddressCount() {
            let cell = tableView.dequeueReusableCell(withIdentifier: addAddressCellIdentifier, for: indexPath)
            configureAddAddressCell(cell)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? AddressCell else {
                return UITableViewCell()
            }
            
            let address = presenter.getAddressAtIndex(index: indexPath.row)
            let isSelected = (indexPath.row == presenter.getCurrentAddressIndex())
            cell.configure(with: address, isSelected: isSelected)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.getAddressCount() {
            presenter.didTapAddAddress()
        } else {
            presenter.didSelectAddress(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < presenter.getAddressCount() else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.presenter.deleteAddress(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    private func configureAddAddressCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = "Add New Address"
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = .marketOrange
        cell.imageView?.image = UIImage(systemName: "plus.circle")
        cell.imageView?.tintColor = .marketOrange
        cell.selectionStyle = .none
    }
    
}

extension AddressSelectionViewController: PromptShowable {
    func showErrorMessage(message: String) {
        showPrompt(message: message) {}
    }
}


extension AddressSelectionViewController: AddressSelectionViewControllerProtocol {
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}
