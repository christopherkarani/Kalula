//
//  LoginController.swift
//  Kalula
//
//  Created by Christopher Brandon Karani on 20/01/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import SnapKit

class LoginController: UIViewController {
    
    let signUpDirectButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dont have an account? Sign up", for: .normal)
        return button
    }()
    
    private func setupViews() {
        view.addSubview(signUpDirectButton)
        
        signUpDirectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(40)
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
        setup()
    }

}
