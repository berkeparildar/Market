//
//  HomeViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    
}

class HomeViewController: UIViewController {

    var presenter: HomePresenterProtocol!
    
    private lazy var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .marketOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .marketOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .marketLightGray
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var marketSectionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "market_poster"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 2, height: 4)
        button.layer.shadowRadius = 6
        button.layer.cornerRadius = 20
        button.imageView?.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var foodSectionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "food_poster"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 2, height: 4)
        button.layer.shadowRadius = 6
        button.layer.cornerRadius = 20
        button.imageView?.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var marketLabel: UILabel = {
        let label = UILabel()
        label.text = "Shop essentials and more, delivered to you!"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .marketYellow
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var foodLabel: UILabel = {
        let label = UILabel()
        label.text = "Browse delicious dishes, ready to order!"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .marketRed
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        button.tintColor = .marketOrange
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.setTitle("Select Address", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 20
        button.backgroundColor = .marketLightOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
        view.addSubview(backgroundView)
        view.addSubview(topBarView)
        topBarView.addSubview(selectAddressButton)
        view.addSubview(foregroundView)
        
        foregroundView.addSubview(marketSectionButton)
        foregroundView.addSubview(foodSectionButton)
        
        marketSectionButton.addSubview(marketLabel)
        foodSectionButton.addSubview(foodLabel)
    }
    
    private func setupConstraints() {
        setupTopViewConstraints()
        setupAddressButtonConstraints()

        setupBackgroundViewConstraints()
        setupForegroundViewConstraints()
        
        setupMarketButtonConstraints()
        setupFoodButtonConstraints()
        
        setupMarketLabelConstraints()
        setupFoodLabelConstraints()
    }
    
    private func setupTopViewConstraints() {
        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    private func setupAddressButtonConstraints() {
        selectAddressButton.snp.makeConstraints { make in
            make.centerX.equalTo(topBarView.snp.centerX)
            make.centerY.equalTo(topBarView.snp.centerY)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
    }
    
    private func setupBackgroundViewConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupForegroundViewConstraints() {
        foregroundView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(20)
        }
    }
    
    private func setupFoodButtonConstraints() {
        foodSectionButton.snp.makeConstraints { make in
            make.top.equalTo(marketSectionButton.snp.bottom).offset(20)
            make.leading.equalTo(foregroundView.snp.leading).offset(20)
            make.trailing.equalTo(foregroundView.snp.trailing).offset(-20)
            make.height.equalTo(foodSectionButton.snp.width).multipliedBy(0.56)
        }
    }

    private func setupMarketButtonConstraints() {
        marketSectionButton.snp.makeConstraints { make in
            make.top.equalTo(foregroundView.snp.top).offset(20)
            make.leading.equalTo(foregroundView.snp.leading).offset(20)
            make.trailing.equalTo(foregroundView.snp.trailing).offset(-20)
            make.height.equalTo(marketSectionButton.snp.width).multipliedBy(0.56)
        }
    }
    
    private func setupMarketLabelConstraints() {
        marketLabel.snp.makeConstraints { make in
            make.centerY.equalTo(marketSectionButton.snp.centerY)
            make.leading.equalTo(marketSectionButton.snp.centerX)
            make.trailing.equalTo(marketSectionButton.snp.trailing).offset(-20)
        }
    }
    
    private func setupFoodLabelConstraints() {
        foodLabel.snp.makeConstraints { make in
            make.centerY.equalTo(foodSectionButton.snp.centerY)
            make.leading.equalTo(foodSectionButton.snp.centerX)
            make.trailing.equalTo(foodSectionButton.snp.trailing).offset(-20)
        }
    }
}

extension HomeViewController: HomeViewProtocol {
    
}
