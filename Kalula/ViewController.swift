//
//  ViewController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 19/12/2017.
//  Copyright © 2017 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import Sukari
import SnapKit
class ViewController: UIViewController {
    
    var stackView: UIStackView!
    
    let imagePickerButton = UIButton(type: .system).this {
        $0.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    let emailTextField = UITextField().this {
        $0.placeholder = "Email"
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
    }
    
    let usernameTextField = UITextField().this {
        $0.placeholder = "Username"
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
    }
    
    let passwordTextField = UITextField().this {
        $0.placeholder = "Password"
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
    }
    
    let signInButton = UIButton(type: .system).this {
        $0.setTitle("Sign In", for: .normal)
        $0.backgroundColor = UIColor(red: 149/255, green: 205/255, blue: 244/255, alpha: 1)
        $0.setTitleColor(.white, for: .normal)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupUIComponents()
    }
}

//MARK: - UI Functionality
extension ViewController {
    fileprivate func setupUIComponents() {
        setupInputComponents()
        setupImagePickerButton()
    }
    
    fileprivate func setupInputComponents() {
        stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signInButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
    }
    
    fileprivate func setupViewController() {
        view.backgroundColor = .white
    }
    
    fileprivate func setupImagePickerButton() {
        view.addSubview(imagePickerButton)
        view.addSubview(stackView)
        
        imagePickerButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(140)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imagePickerButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().inset(40)
            $0.height.equalTo(220)
        }
    }
}

