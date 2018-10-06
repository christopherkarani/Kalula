//
//  LoginController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 20/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit
import Hero
import Toaster
import Firebase


class LoginController: UIViewController {
    
    var session: Session
    private var stackView: UIStackView!
    private var theme: UIColor = UIColor.greenTheme
    
    lazy var bannerView: UIView = { [weak self] in
        guard let strongSelf = self else { return UIView() }
        let view = UIView()
        view.backgroundColor = theme
        setupBanner(inside: view)
        return view
    }()
    
    // setupbanner
    private func setupBanner(inside view: UIView) {
        view.addSubview(bannerLabel)
        bannerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private let bannerLabel : UILabel = {
        let label = UILabel()
        label.text = "Kalula"
        label.font = UIFont(name: "Candy Shop Personal Use", size: 50)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    lazy  var signUpDirectButton : UIButton = { [weak self] in
        guard let strongSelf = self else { return UIButton() }
        let attributes : [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 15)]
        var attributedString = NSMutableAttributedString(string: "Dont have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign up", attributes: [.font: UIFont.boldSystemFont(ofSize: 15),
                                                                                   .foregroundColor: UIColor.greenTheme]))
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(strongSelf, action: #selector(handleShowSignUpVC), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
        }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(handleTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    
    
    lazy var signInButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = theme
        button.alpha = 0.5
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleLogin() {
        view.endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        // log user in using email and password
        session.user(auth: .login(email: email, password: password)) { (result ) in
            switch result {
            case .success:
                // There is a bug here
                self.dismiss(animated: true, completion: nil)
            case .failure(let err):
                self.passwordTextField.text = nil
                self.show(alert: err)
            }
        }
    }
    

    
    var isValidTextForm: Bool = false  {
        didSet(value) {
            switch value {
            case true:
                signInButton.alpha = 1
                signInButton.isUserInteractionEnabled = true
            case false:
                signInButton.alpha = 0.5
                signInButton.isUserInteractionEnabled = false
            }
        }
    }
    @objc private func handleTextFieldEditingChanged() {
        guard let emailCount = emailTextField.text?.count, let passwordCount = passwordTextField.text?.count else {
            print("TextField is invalid")
            isValidTextForm = false
            return
        }
        switch isValidTextForm {
        case (emailCount > 5) && (passwordCount > 5):
            isValidTextForm = true
            return
        default:
            signInButton.alpha = 0.5
            signInButton.isUserInteractionEnabled = false
            return
        }
    }
    
    
    @objc private func handleShowSignUpVC() {
        let signUpVC = SignUpController(session: Session())
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func setupInputViews() {
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(bannerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
    }
    
    private func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTapGesture))
        view.addGestureRecognizer(tap)
        
        view.addSubview(bannerView)
        view.addSubview(signUpDirectButton)
        
        bannerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(200)
        }
        
        signUpDirectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    @objc private func handleScreenTapGesture() {
        view.endEditing(true)
    }
    
    private func setupHeroToNavigationBar() {
        navigationController?.isHeroEnabled = true
        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoomSlide(direction: .left), dismissing: .zoomSlide(direction: .right))
    }
    
    
    /// 
    private func setup() {
        setupHeroToNavigationBar()
        setupViews()
        setupInputViews() // always called after setupViews()
    }
    
    init(session: Session) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setup()
    }
}
