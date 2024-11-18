//
//  AddressSaveViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

import UIKit

protocol AddressSaveViewControllerProtocol: AnyObject {
    func setCurrentAddressLabel(with address: String)
    func showInfoPopUp(with message: String, action: @escaping () -> Void)
}

class AddressSaveViewController: UIViewController {

    var presenter: AddressSavePresenterProtocol!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Address Information"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .marketOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentAddressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressFieldsTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressSaveCell.self, forCellReuseIdentifier: AddressSaveCell.identifier)
        tableView.isScrollEnabled = false
        tableView.rowHeight = 64
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var contactTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Information"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .marketOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contactFieldsTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressSaveCell.self, forCellReuseIdentifier: AddressSaveCell.identifier)
        tableView.isScrollEnabled = false
        tableView.rowHeight = 64
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Save  ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .marketOrange
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(saveAddress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Save Address"
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        presenter.getCurrentAddress()

        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        // Remove observers on deinitialization
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func saveAddress() {
        presenter.saveAddress()
    }
 
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(addressTitleLabel)
        contentView.addSubview(currentAddressLabel)
        contentView.addSubview(addressFieldsTable)
        contentView.addSubview(contactTitleLabel)
        contentView.addSubview(contactFieldsTable)
        contentView.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        // ScrollView constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // ContentView constraints
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView) // Ensure contentView matches scrollView's width
        }
        
        // Constraints for all elements within contentView
        setupAddressTitleLabelConstraints()
        setupCurrentAddressLabelConstraints()
        setupAddressTableConstraints()
        setupContactTitleLabelConstraints()
        setupContactTableConstraints()
        setupSaveButtonConstraints()
        
        // This is important to allow scrolling when the content size is larger than the screen
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(saveButton.snp.bottom).offset(20)
        }
    }
    
    private func setupAddressTitleLabelConstraints() {
        addressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
    }
    
    private func setupCurrentAddressLabelConstraints() {
        currentAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
    }
        
    private func setupAddressTableConstraints() {
        let numberOfRows = presenter.getAddressFieldCount()
        let tableViewHeight = CGFloat(numberOfRows) * 64
        
        addressFieldsTable.snp.makeConstraints { make in
            make.top.equalTo(currentAddressLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(tableViewHeight)
        }
    }
    
    private func setupContactTitleLabelConstraints() {
        contactTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(addressFieldsTable.snp.bottom).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
    }
    
    private func setupContactTableConstraints() {
        let numberOfRows = presenter.getContactFieldCount()
        let tableViewHeight = CGFloat(numberOfRows) * 64
        
        contactFieldsTable.snp.makeConstraints { make in
            make.top.equalTo(contactTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(tableViewHeight)
        }
    }
    
    private func setupSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(contactFieldsTable.snp.bottom).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    // MARK: - Keyboard Handling
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension AddressSaveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addressFieldsTable {
            return presenter.getAddressFieldCount()
        } else {
            return presenter.getContactFieldCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: AddressSaveCell.identifier,
                for: indexPath) as? AddressSaveCell else {
            return UITableViewCell()
        }
        var addressSaveEntity: AddressSaveEntity? = nil
        if tableView == addressFieldsTable {
            addressSaveEntity = presenter.getAddressField(at: indexPath.row)
        } else {
            addressSaveEntity = presenter.getContactField(at: indexPath.row)
        }
        cell.configure(with: addressSaveEntity!)
        cell.selectionStyle = .none
        return cell
    }
}

extension AddressSaveViewController: AddressSaveViewControllerProtocol, InfoPopUpShowable {
    func showInfoPopUp(with message: String, action: @escaping () -> Void) {
        showInfoPopUp(message: message, confirm: action)
    }
    
    func setCurrentAddressLabel(with address: String) {
        currentAddressLabel.text = address
    }
}
