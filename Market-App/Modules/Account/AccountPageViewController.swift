//
//  AccountViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

import UIKit

protocol AccountPageViewControllerProtocol {
    
}

class AccountPageViewController: UIViewController {

    var presenter: AccountPagePresenterProtocol!
    
    private lazy var accountSettingsTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Account"
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(accountSettingsTable)
    }
    
    private func setupConstraints() {
        accountSettingsTable.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
        
}

extension AccountPageViewController: AccountPageViewControllerProtocol {
    
}

extension AccountPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getAccountSettingsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let accountSettings = presenter.getAccountSettings(at: indexPath.row)
        cell.textLabel?.text = accountSettings.name
        cell.textLabel?.font = .systemFont(ofSize: 18)
        cell.imageView?.image = UIImage(systemName: accountSettings.symbolName)
        cell.imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .medium)
        cell.imageView?.tintColor = .marketOrange
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectSetting(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
