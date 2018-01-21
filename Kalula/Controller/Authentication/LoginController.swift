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
    
    lazy var bannerView: UIView = { [weak self] in
        guard let strongSelf = self else { return UIView() }
        let view = UIView()
        view.backgroundColor = UIColor.theme
        setupBanner(inside: view)
        return view
    }()
    private func setupBanner(inside view: UIView) {
        view.addSubview(bannerLabel)
        bannerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    let bannerLabel = UILabel().this {
        $0.text = "Kalula"
        $0.font = UIFont(name: "Rainbow Bridge Personal Use", size: 30)
        $0.textColor = .white
    }
    
    
   lazy  var signUpDirectButton : UIButton = { [weak self] in
        guard let strongSelf = self else { return UIButton() }
        let button = UIButton(type: .system)
        button.setTitle("Dont have an account? Sign up", for: .normal)
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
        
        $0.backgroundColor = UIColor.rgb(red: 255, green: 215, blue: 0)
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
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setup()
    }

}
