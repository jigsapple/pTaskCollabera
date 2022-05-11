//
//  LoginViewController.swift
//  pTaskCollabera
//
//  Created by Jignesh on 11/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class LoginViewController : UIViewController {
    
    //Create textfield
    lazy var textFiledEmail:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email Id"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //Create textfield
    lazy var textFieldPassword :UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //Create Login button
    lazy var btnLogin : UIButton = {
       let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onTapBtnLogin), for: .touchUpInside)
        return btn
    }()
    
    //Create Instruction lable
    lazy var lblInfo : UILabel = {
       let label = UILabel()
        label.text = "please enter the valid email id and atleast 6 character to enable login button"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createObservables()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(textFiledEmail)
        self.view.addSubview(textFieldPassword)
        self.view.addSubview(lblInfo)
        self.view.addSubview(btnLogin)
        
        NSLayoutConstraint.activate([
            textFiledEmail.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFiledEmail.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            textFiledEmail.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 200),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            textFieldPassword.topAnchor.constraint(equalTo: textFiledEmail.bottomAnchor,constant: 20),
            lblInfo.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            lblInfo.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            lblInfo.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 40),
            lblInfo.heightAnchor.constraint(equalToConstant: 30),
            btnLogin.topAnchor.constraint(equalTo: lblInfo.bottomAnchor,constant: 10),
            btnLogin.widthAnchor.constraint(equalTo: textFiledEmail.widthAnchor),
            btnLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btnLogin.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createObservables() {
        textFiledEmail.rx.text.map({$0 ?? ""}).bind(to: viewModel.email).disposed(by: bag)
        textFieldPassword.rx.text.map({$0 ?? ""}).bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValidInput.bind(to: btnLogin.rx.isEnabled).disposed(by: bag)
        viewModel.isValidInput.subscribe( onNext: { [weak self] isValid in
            self?.btnLogin.backgroundColor = isValid ? .systemBlue.withAlphaComponent(1.0) : .systemBlue.withAlphaComponent(0.3)
        }).disposed(by: bag)
    }
    
    
    @objc func onTapBtnLogin() {
        let dashboardVC = DashboardViewController()
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
    
}
