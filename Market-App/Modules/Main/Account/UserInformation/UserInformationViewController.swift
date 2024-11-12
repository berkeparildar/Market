//
//  UserInformationViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

import UIKit

protocol UserInformationViewControllerProtocol: AnyObject {
    func showResultPrompt(with message: String)
    func reloadTableView()
}

class UserInformationViewController: UIViewController {
    
    private lazy var userInformationTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserInformationCell.self,
                           forCellReuseIdentifier: UserInformationCell.identifier)
        tableView.isScrollEnabled = false
        tableView.rowHeight = 64
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  Save  ", for: .normal)
        button.backgroundColor = .marketOrange
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        

    var presenter: UserInformationPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.getUserData()
        title = "User Information"
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(userInformationTable)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        setupTableConstraints()
        setupSaveButtonConstraints()
    }
    
    @objc private func didTapSaveButton() {
        presenter.updateUserInformation()
    }
    
    private func setupTableConstraints() {
        let numberOfRows = presenter.getUserInformationEntityCount()
        let tableViewHeight = CGFloat(numberOfRows) * 64
        
        userInformationTable.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(tableViewHeight)
        }
    }
   
    private func setupSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(userInformationTable.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
}

extension UserInformationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getUserInformationEntityCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserInformationCell.identifier, for: indexPath) as?
                UserInformationCell else {
            return UITableViewCell()
        }
        
        let userInfoEntity = presenter.getUserInformationEntity(at: indexPath.row)
        cell.configure(with: userInfoEntity)
        cell.selectionStyle = .none
        return cell
    }
}

extension UserInformationViewController: UserInformationViewControllerProtocol, InfoPopUpShowable {
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            userInformationTable.reloadData()
        }
    }
    
    func showResultPrompt(with message: String) {
        showInfoPopUp(message: message) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
