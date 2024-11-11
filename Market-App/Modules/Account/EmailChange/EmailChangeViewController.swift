//
//  EmailChangeViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

import UIKit

protocol EmailChangeViewControllerProtocol: AnyObject {
    func reloadTableView()
    func showMessage(message: String, action: @escaping () -> Void)
    func dismissView()
}

class EmailChangeViewController: UIViewController {
    
    var presenter: EmailChangePresenterProtocol!
    
    private lazy var emailChangeTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmailChangeCell.self, forCellReuseIdentifier: EmailChangeCell.identifier)
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
        button.addTarget(self, action: #selector(saveUserInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Email"
        view.backgroundColor = .white
        presenter.getCurrentEmail()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.getEmailVerifiedStatus()
    }
    
    @objc private func saveUserInfo() {
        presenter.updateEmail()
    }
    
    private func setupViews() {
        view.addSubview(emailChangeTable)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
       setupTableConstraints()
        setupSaveButtonConstraints()
    }
    
    private func setupTableConstraints() {
        let numberOfRows = presenter.getEmailChangeEntityCount()
        let tableViewHeight = CGFloat(numberOfRows) * 64
        
        emailChangeTable.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(tableViewHeight)
        }
    }
    
    private func setupSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(emailChangeTable.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
}

extension EmailChangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getEmailChangeEntityCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EmailChangeCell.identifier, for: indexPath) as? EmailChangeCell else {
            return UITableViewCell()
        }
        
        let emailEntity = presenter.getEmailChangeEntity(at: indexPath.row)
        cell.configure(with: emailEntity)
        cell.selectionStyle = .none
        return cell
    }
}

extension EmailChangeViewController: EmailChangeViewControllerProtocol, InfoPopUpShowable {
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            emailChangeTable.reloadData()
        }
    }
    
    func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    func showMessage(message: String, action: @escaping () -> Void) {
        showInfoPopUp(message: message, confirm: action)
    }
    
    
}
