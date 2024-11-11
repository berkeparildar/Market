//
//  SignInViewController.swift
//  Market-App
//
//  Created by Berke Parıldar on 30.10.2024.
//

import UIKit
import SnapKit

protocol AuthenticationViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showErrorMessage(message: String)
    func showSuccessMessage(completion: @escaping () -> Void)
}

final class AuthenticationViewController: UIViewController {
    
    var presenter: AuthenticationPresenterProtocol!
    
    private lazy var coloredBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .marketGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var marketLabel: UILabel = {
        let label = UILabel()
        label.text = "Market"
        label.font = .systemFont(ofSize: 48, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var marketIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart.circle.fill")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Sign In related Views
    private lazy var signInFormBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var signInEmailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-Mail"
        textField.backgroundColor = .marketLightGray
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signInPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.backgroundColor = .marketLightGray
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.rightView = signInPasswordToggleButton
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signInPasswordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.addTarget(self, action: #selector(toggleSignInPasswordVisibility),
                               for: .touchUpInside)
        button.tintColor = .marketGreen
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 12), forImageIn: .normal)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot your password?", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.marketGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .marketGreen
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Not a member?"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signUpFormButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.marketGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(signUpFormButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Sign Up related Views
    private lazy var signUpFormBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var signUpEmailTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "E-Mail"
        textField.backgroundColor = .marketLightGray
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signUpPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .password
        textField.backgroundColor = .marketLightGray
        textField.borderStyle = .roundedRect
        textField.rightView = signUpPasswordToggleButton
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signUpPasswordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .marketGreen
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 12), forImageIn: .normal)
        button.addTarget(self, action: #selector(toggleSignUpPasswordVisibility),
                               for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .marketGreen
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Already a member?"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signInFormButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.marketGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(signInFormButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(coloredBackground)
        view.addSubview(marketLabel)
        view.addSubview(marketIcon)
        
        view.addSubview(signInFormBackgroundView)
        signInFormBackgroundView.addSubview(signInEmailTextField)
        signInFormBackgroundView.addSubview(signInPasswordTextField)
        signInFormBackgroundView.addSubview(forgotPasswordButton)
        signInFormBackgroundView.addSubview(signInButton)
        signInFormBackgroundView.addSubview(signUpLabel)
        signInFormBackgroundView.addSubview(signUpFormButton)
        
        view.addSubview(signUpFormBackgroundView)
        signUpFormBackgroundView.addSubview(signUpEmailTextField)
        signUpFormBackgroundView.addSubview(signUpPasswordTextField)
        signUpFormBackgroundView.addSubview(signUpButton)
        signUpFormBackgroundView.addSubview(signInLabel)
        signUpFormBackgroundView.addSubview(signInFormButton)
    }
    
    func setupConstraints() {
        setupColoredBackgroundConstraints()
        setupMarketLabelConstraints()
        setupMarketIconConstraints()
        
        setupSignInFormBackgroundConstraints()
        setupSignInEmailTextFieldConstrainsts()
        setupSignInPasswordTextFieldConstrainsts()
        setupForgotPasswordButtonConstrainsts()
        setupSignInButtonConstrainsts()
        setupSignUpLabelConstrainsts()
        setupSignUpFormButtonConstrainsts()
        
        setupSignUpFormBackgroundViewConstrainsts()
        setupSignUpEmailTextFieldConstrainsts()
        setupSignUpPasswordTextFieldConstrainsts()
        setupSignUpButtonConstrainsts()
        setupSignInLabelConstrainsts()
        setupSignInFormButtonConstrainsts()
    }
    
    //MARK: - Button functions
    @objc func signInButtonTapped() {
        let emailString = self.signInEmailTextField.text ?? ""
        let passwordString = self.signInPasswordTextField.text ?? ""
        presenter.didTapSignIn(email: emailString, password: passwordString)
    }
    
    @objc func signUpButtonTapped() {
        let emailString = self.signUpEmailTextField.text ?? ""
        let passwordString = self.signUpPasswordTextField.text ?? ""
        presenter.didTapSignUp(email: emailString, password: passwordString)
    }
    
    @objc func toggleSignInPasswordVisibility() {
        signInPasswordTextField.isSecureTextEntry.toggle()
        signInPasswordToggleButton.isSelected.toggle()
    }
    
    @objc func toggleSignUpPasswordVisibility() {
        signUpPasswordTextField.isSecureTextEntry.toggle()
        signUpPasswordToggleButton.isSelected.toggle()
    }
    
    @objc func forgotPasswordButtonTapped() {
        
    }
    
    @objc func signUpFormButtonTapped() {
        UIView.animate(
            withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.signInFormBackgroundView.transform = CGAffineTransform(
                    translationX: -self.view.frame.width, y: 0)
                self.signUpFormBackgroundView.transform = .identity
                })
    }
    
    @objc func signInFormButtonTapped() {
        UIView.animate(
            withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.signUpFormBackgroundView.transform = CGAffineTransform(
                    translationX: self.view.frame.width, y: 0)
                self.signInFormBackgroundView.transform = .identity
                })
    }
    
    func setupColoredBackgroundConstraints() {
        coloredBackground.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-64)
            make.top.equalToSuperview()
        }
    }
    
    func setupMarketLabelConstraints() {
        marketLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-32)
            make.top.equalToSuperview().offset(120)
        }
    }
    
    func setupMarketIconConstraints() {
        marketIcon.snp.makeConstraints { make in
            make.leading.equalTo(marketLabel.snp.trailing).offset(8)
            make.centerY.equalTo(marketLabel.snp.centerY)
            make.height.equalTo(64)
            make.width.equalTo(64)
        }
    }
    
    func setupSignInFormBackgroundConstraints() {
        signInFormBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(marketLabel.snp.bottom).offset(64)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(signUpLabel.snp.bottom).offset(16)
        }
    }
    
    func setupSignInEmailTextFieldConstrainsts() {
        signInEmailTextField.snp.makeConstraints { make in
            make.leading.equalTo(signInFormBackgroundView.snp.leading).inset(16)
            make.trailing.equalTo(signInFormBackgroundView.snp.trailing).inset(16)
            make.top.equalTo(signInFormBackgroundView.snp.top).inset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignInPasswordTextFieldConstrainsts() {
        signInPasswordTextField.snp.makeConstraints { make in
            make.leading.equalTo(signInFormBackgroundView.snp.leading).inset(16)
            make.trailing.equalTo(signInFormBackgroundView.snp.trailing).inset(16)
            make.top.equalTo(signInEmailTextField.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupForgotPasswordButtonConstrainsts() {
        forgotPasswordButton.snp.makeConstraints { make in
            make.trailing.equalTo(signInFormBackgroundView.snp.trailing).inset(16)
            make.top.equalTo(signInPasswordTextField.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignInButtonConstrainsts() {
        signInButton.snp.makeConstraints { make in
            make.leading.equalTo(signInFormBackgroundView.snp.leading).inset(16)
            make.trailing.equalTo(signInFormBackgroundView.snp.trailing).inset(16)
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignUpLabelConstrainsts() {
        signUpLabel.snp.makeConstraints { make in
            make.centerX.equalTo(signInFormBackgroundView.snp.centerX).offset(-32)
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignUpFormButtonConstrainsts() {
        signUpFormButton.snp.makeConstraints { make in
            make.centerX.equalTo(signInFormBackgroundView.snp.centerX).offset(48)
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignUpFormBackgroundViewConstrainsts() {
        signUpFormBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(marketLabel.snp.bottom).offset(64)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(signInLabel.snp.bottom).offset(16)
        }
        
        self.signUpFormBackgroundView.transform = CGAffineTransform(
            translationX: self.view.frame.width, y: 0)
    }
    
    func setupSignUpEmailTextFieldConstrainsts() {
        signUpEmailTextField.snp.makeConstraints { make in
            make.leading.equalTo(signUpFormBackgroundView.snp.leading).inset(16)
            make.trailing.equalTo(signUpFormBackgroundView.snp.trailing).inset(16)
            make.top.equalTo(signUpFormBackgroundView.snp.top).inset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignUpPasswordTextFieldConstrainsts() {
        signUpPasswordTextField.snp.makeConstraints { make in
            make.leading.equalTo(signUpFormBackgroundView.snp.leading).inset(16)
            make.trailing.equalTo(signUpFormBackgroundView.snp.trailing).inset(16)
            make.top.equalTo(signUpEmailTextField.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignUpButtonConstrainsts() {
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(signUpFormBackgroundView.snp.leading).inset(16)
            make.trailing.equalTo(signUpFormBackgroundView.snp.trailing).inset(16)
            make.top.equalTo(signUpPasswordTextField.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignInLabelConstrainsts() {
        signInLabel.snp.makeConstraints { make in
            make.centerX.equalTo(signUpFormBackgroundView.snp.centerX).offset(-32)
            make.top.equalTo(signUpButton.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    func setupSignInFormButtonConstrainsts() {
        signInFormButton.snp.makeConstraints { make in
            make.centerX.equalTo(signUpFormBackgroundView.snp.centerX).offset(56)
            make.top.equalTo(signUpButton.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
}

extension AuthenticationViewController:
    AuthenticationViewControllerProtocol, LoadingShowable, InfoPopUpShowable {
    func showErrorMessage(message: String) {
        showInfoPopUp(message: message, confirm: {})
    }
    
    func showSuccessMessage(completion confirmAction: @escaping () -> Void) {
        showInfoPopUp(message: "Sign Up successful!", confirm: confirmAction)
    }
    
    func showLoadingIndicator() {
        showLoading()
    }
    
    func hideLoadingIndicator() {
        hideLoading()
    }
}

