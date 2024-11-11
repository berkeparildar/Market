//
//  PasswordChangeViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

import UIKit

protocol PasswordChangeViewControllerProtocol: AnyObject {
    func showMessage(message: String, action: @escaping () -> Void)
    func navigateToLogin()
}

class PasswordChangeViewController: UIViewController {
    
    var presenter: PasswordChangePresenterProtocol!
    
    private lazy var passwordChangeTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PasswordChangeCell.self, forCellReuseIdentifier: "PasswordCell")
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
        title = "Change Password"
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    @objc private func saveUserInfo() {
        presenter.didTapChangePassword()
    }
    
    private func setupViews() {
        view.addSubview(passwordChangeTable)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        setupTableConstraints()
        setupSaveButtonConstraints()
    }
    
    private func setupTableConstraints() {
        let numberOfRows = presenter.getPasswordEntryCount()
        let tableViewHeight = CGFloat(numberOfRows) * 64
        
        passwordChangeTable.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(tableViewHeight)
        }
    }
    
    private func setupSaveButtonConstraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(passwordChangeTable.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
    }
}

extension PasswordChangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getPasswordEntryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell",
                                                       for: indexPath) as? PasswordChangeCell else {
            return UITableViewCell()
        }
        
        let passwordEntry = presenter.getPasswordEntry(at: indexPath.row)
        cell.configure(with: passwordEntry)
        cell.selectionStyle = .none
        return cell
    }
}


extension PasswordChangeViewController: PasswordChangeViewControllerProtocol, PromptShowable {
    func navigateToLogin() {
        guard let window = self.view.window else { return }
        let signInVC = AuthenticationRouter.createModule()
        let navigationController = UINavigationController(rootViewController: signInVC)
        window.rootViewController = navigationController
    }
    
    func showMessage(message: String, action: @escaping () -> Void) {
        showPrompt(message: message, confirm: action)
    }
}
