//
//  HomeViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 7.11.2024.
//

import UIKit

protocol DeliverityViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func setAddress(address: String)
    func showInfoPopUp(message: String, action: @escaping () -> Void)
}

class DeliverityViewController: UIViewController {
    
    var presenter: DeliverityPresenterProtocol!
    
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
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "market_poster"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 2, height: 4)
        button.layer.shadowRadius = 6
        button.layer.cornerRadius = 20
        button.imageView?.layer.cornerRadius = 20
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(marketButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var foodSectionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "food_poster"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 2, height: 4)
        button.layer.shadowRadius = 6
        button.layer.cornerRadius = 20
        button.imageView?.layer.cornerRadius = 20
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(foodButtonTapped), for: .touchUpInside)
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
        button.layer.cornerRadius = 20
        button.backgroundColor = .marketLightOrange
        button.addTarget(self, action: #selector(addressButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var addressButtonPinImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "pin.fill")
        imageView.image = image
        imageView.tintColor = .marketYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addressButtonArrowImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.image = image
        imageView.tintColor = .marketYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "logo")
        imageView.image = image
        imageView.tintColor = .marketYellow
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addressButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Address"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setCurrentAddress()
        setupViews()
        setupConstraints()
        navigationItem.titleView = selectAddressButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        presenter.updateCurrentAddress()
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(foregroundView)
        view.addSubview(logoImage)
        
        selectAddressButton.addSubview(addressButtonPinImage)
        selectAddressButton.addSubview(addressButtonArrowImage)
        selectAddressButton.addSubview(addressButtonLabel)
        
        foregroundView.addSubview(marketSectionButton)
        foregroundView.addSubview(foodSectionButton)
        
        marketSectionButton.addSubview(marketLabel)
        foodSectionButton.addSubview(foodLabel)
    }
    
    private func setupConstraints() {
        setupAddressButtonConstraints()
        
        setupBackgroundViewConstraints()
        setupForegroundViewConstraints()
        
        setupMarketButtonConstraints()
        setupFoodButtonConstraints()
        
        setupMarketLabelConstraints()
        setupFoodLabelConstraints()
        
        setupAddressButtonPinConstraints()
        setupAddressButtonArrowConstraints()
        setupAddressButtonLabelConstraints()
        setupLogoImageConstraints()
    }
    
    private func setupAddressButtonConstraints() {
        selectAddressButton.snp.makeConstraints { make in
            make.height.equalTo(40)
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
            make.top.equalTo(marketSectionButton.snp.top).offset(-20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(16)
        }
    }
    
    private func setupMarketButtonConstraints() {
        marketSectionButton.snp.makeConstraints { make in
            make.bottom.equalTo(foodSectionButton.snp.top).offset(-20)
            make.leading.equalTo(foregroundView.snp.leading).offset(20)
            make.trailing.equalTo(foregroundView.snp.trailing).offset(-20)
            make.height.equalTo(marketSectionButton.snp.width).multipliedBy(0.56)
        }
    }
    
    private func setupFoodButtonConstraints() {
        foodSectionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalTo(foregroundView.snp.leading).offset(20)
            make.trailing.equalTo(foregroundView.snp.trailing).offset(-20)
            make.height.equalTo(foodSectionButton.snp.width).multipliedBy(0.56)
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
    
    private func setupAddressButtonPinConstraints() {
        addressButtonPinImage.snp.makeConstraints { make in
            make.leading.equalTo(selectAddressButton.snp.leading).offset(20)
            make.centerY.equalTo(selectAddressButton.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
    }
    
    private func setupAddressButtonArrowConstraints() {
        addressButtonArrowImage.snp.makeConstraints { make in
            make.trailing.equalTo(selectAddressButton.snp.trailing).offset(-20)
            make.centerY.equalTo(selectAddressButton.snp.centerY)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
    }
    
    private func setupAddressButtonLabelConstraints() {
        addressButtonLabel.snp.makeConstraints { make in
            make.leading.equalTo(addressButtonPinImage.snp.trailing).offset(4)
            make.trailing.equalTo(addressButtonArrowImage.snp.leading).offset(-4)
            make.centerY.equalTo(selectAddressButton.snp.centerY)
        }
    }
    
    private func setupLogoImageConstraints() {
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(foregroundView.snp.top).offset(-20)
            make.width.equalTo(logoImage.snp.height).multipliedBy(1)
            make.centerX.equalToSuperview()
        }
    }
}

extension DeliverityViewController {
    @objc private func foodButtonTapped() {
        presenter.didTapFoodButton()
    }
    
    @objc private func marketButtonTapped() {
        presenter.didTapMarketButton()
    }
    
    @objc private func addressButtonTapped() {
        presenter.didTapAddressButton()
    }
}

extension DeliverityViewController: DeliverityViewControllerProtocol,
                                        LoadingShowable,
                                        InfoPopUpShowable {
    func showInfoPopUp(message: String, action: @escaping () -> Void) {
        showInfoPopUp(message: message, confirm: action)
    }
    
    func setAddress(address: String) {
        addressButtonLabel.text = address
    }
    
    func showLoadingIndicator() {
        showLoading()
    }
    
    func hideLoadingIndicator() {
        hideLoading()
    }
}
