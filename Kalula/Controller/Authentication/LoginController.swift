//
//  LoginController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 20/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit
import Sukari

class LoginController: UIViewController {
    
    private var stackView: UIStackView!
    private var colorTheme: UIColor = UIColor.greenTheme
    
    lazy var bannerView: UIView = { [weak self] in
        guard let strongSelf = self else { return UIView() }
        let view = UIView()
        view.backgroundColor = colorTheme
        setupBanner(inside: view)
        return view
    }()
    private func setupBanner(inside view: UIView) {
        view.addSubview(bannerLabel)
        bannerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private let bannerLabel = UILabel().this {
        $0.text = "Kalula"
        $0.font = UIFont(name: "Candy Shop Personal Use", size: 50)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    
    lazy  var signUpDirectButton : UIButton = { [weak self] in
        guard let strongSelf = self else { return UIButton() }
        let attributes : [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 15)]
        var attributedString = NSMutableAttributedString(string: "Dont have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        attributedString.append(NSAttributedString(string: "Sign up", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)]))
        
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(strongSelf, action: #selector(handleShowSignUpVC), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
        }()
    
    let emailTextField = UITextField().this {
        $0.placeholder = "Email"
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        //$0.addTarget(self, action: #selector(handleTextFieldEditingChanged), for: .editingChanged)
    }
    
    let passwordTextField = UITextField().this {
        $0.placeholder = "Password"
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.isSecureTextEntry = true
        //$0.addTarget(self, action: #selector(handleTextFieldEditingChanged), for: .editingChanged)
    }
    
    lazy var signInButton = UIButton(type: .system).this {
        $0.setTitle("Login", for: .normal)
        
        $0.backgroundColor = UIColor.greenTheme
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
        //$0.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
    
    @objc private func handleShowSignUpVC() {
        let signUpVC = SignUpController(loginService: LoginManager())
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func setupInputViews() {
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
            $0.bottom.equalToSuperview().inset(40)
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func setup() {
        setupViews()
        setupInputViews() // always called after setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setup()
    }

}
