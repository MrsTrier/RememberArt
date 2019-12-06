//
//  AuthoriseUserViewController.swift
//  RememberArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AuthoriseUserViewController: UIViewController {

    var userWish: String?
    var userInfoStack = UIStackView()
    var nameField = UITextField()
    var familyNameField = UITextField()
    var logInField = UITextField()
    var passwordField = UITextField()
    var errorLable = UILabel()
    
    convenience init() {
        self.init(nil)
    }
    
    init(_ wish: String?) {
        super.init(nibName: nil, bundle: nil)
        self.userWish = wish
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoStack = CreateFieldsStack(acordinToThe: userWish)
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .gray
        view.addSubview(userInfoStack)
        setupConstraints()
    }
    
    func createTextField(text: String) -> UITextField {
        let field = UITextField()
        
        field.layer.cornerRadius = 15
        field.backgroundColor = .white
        field.textColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        field.textAlignment = .center
        let placeholder = NSAttributedString(string: text)
        field.attributedPlaceholder = placeholder
        return field
    }
    
    func CreateFieldsStack(acordinToThe userWish: String?) -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        headerView.axis = .vertical
        headerView.distribution = .fillEqually
        headerView.alignment = .fill
        
        if userWish == "Sign Up" {
            self.nameField = createTextField(text: "Your name")
            self.familyNameField = createTextField(text: "Your surname")
            headerView.addArrangedSubview(nameField)
            headerView.addArrangedSubview(familyNameField)
        }
        self.logInField = createTextField(text: "Email")
        self.passwordField = createTextField(text: "Password")

        errorLable.textColor = .red
        errorLable.text = "Error"
        errorLable.numberOfLines = 0
        
        errorLable.sizeToFit()
        errorLable.alpha = 0
        
        let signUpButton = UIButton()
        signUpButton.setTitleColor(.blue, for: .normal)

        signUpButton.tintColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        signUpButton.setTitle((userWish == "Sign Up") ? "Sign Up" : "Log in", for: .normal)
        
        signUpButton.addTarget(self, action: (userWish == "Sign Up") ? #selector(signUpButtonTapped) : #selector(logInButtonTapped), for: .touchUpInside)
        
        headerView.spacing = 15.0
        
        headerView.addArrangedSubview(logInField)
        headerView.addArrangedSubview(passwordField)

        headerView.addArrangedSubview(errorLable)
        headerView.addArrangedSubview(signUpButton)

        return headerView
    }
    
    
    func setupConstraints() {

        userInfoStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        userInfoStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        userInfoStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        userInfoStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400).isActive = true
        
    }

    @objc func logInButtonTapped() {
        let cleanPassword = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = logInField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanPassword == "" || cleanEmail == "" {
            // При вводе данных пользователь допустил ошибку
            self.showError("Email или пароль введены с ошибкой")
        }
        
        Auth.auth().signIn(withEmail: cleanEmail!, password: cleanPassword!) { (result, error) in
            if error != nil {
                self.errorLable.text = error!.localizedDescription
                self.errorLable.alpha = 1
            } else {
                // Поздравляю с авторизацией!
                
                // Смена экрана
                self.showViewForLogedinUser()
            }
        }
    }
    
    /// Проверяет коректность пользовательской информации в текстовых полях
    ///
    /// - Returns: nil - если поля заполнены правильно, errorMessage - если пользователь нарушил требования
    func fieldsValidation() -> String? {
        // Проверка что во всех полях есть значения
        let cleanPassword = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if familyNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cleanPassword == "" ||
            logInField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Пожалуйста заполни каждое поле!"
        }
        
        // Проверка на безопасность пароля
        if Utilities.isPasswordValid(cleanPassword!) == false {
            // Пароль содержит недостаточно символов что бы считать его безопасным
            return "Пожалуйста придумай пароль, где будет минимум 8 символов, включая специальные символы"
            
        }
        return nil
    }
    
    @objc func signUpButtonTapped() {
        
        // Валидация значений полей
        if let error = fieldsValidation() {
            // При вводе данных пользователь допустил ошибку
            showError(error)
        } else {
            // Данные пользователя очищенные от пробелов
            let firstName = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = familyNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let login = logInField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Создание пользователя
            Auth.auth().createUser(withEmail: login, password: password) { (result, err) in
                // Ошибка при создании пользователя
                if err != nil {
                    self.showError("Упс, что-то пошло не так при создании пользователя")
                } else {
                    // Пользователь создан, сохраняем имя и фамилию присваиваем уникальный id
                    let usersDataBase = Firestore.firestore()
                    usersDataBase.collection("usersDataBase").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result?.user.uid], completion: { (error) in
                        if error != nil {
                            self.showError("Произошла ошибка при сохранении имени и фамилии")
                        } else {
                            // Смена экрана
                            self.showViewForLogedinUser()
                        }
                    })
                    
                }
            }
        }
    }
    
    func showViewForLogedinUser() {
        let  startvc =  self.navigationController?.viewControllers.filter({$0 is StartView}).first
        let  authvc =  self.navigationController?.viewControllers.filter({$0 is AuthoriseUserViewController}).first
        navigationController?.popToViewController(startvc ?? authvc!, animated: true)

    }
    
    func showError(_ message: String) {
        errorLable.text = message
        errorLable.alpha = 1
    }
    
}

extension AuthoriseUserViewController {
    var topDistance : CGFloat{
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
}
