//
//  SignUpVC.swift
//  LoginPro
//
//  Created by Abhishek on 21/07/24.
//

import UIKit

class SignUpVC: UIViewController {
    
    private var firstName = ""
    private var lastName = ""
    private var email = ""
    private var password = ""

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    

    //MARK: - Button Actions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {

    }


    //MARK: - Functions
    private func isValidForSignUp() -> Bool {
        
        let confirmPassword = confirmPasswordTextField.text ?? ""
        email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        password = passwordTextField.text ?? ""
        firstName = firstNameTextField.text ?? ""
        lastName = lastNameTextField.text ?? ""
        
        if !Validation_Model.validateWhiteSpace(firstName) {
            self.view.makeToast(ToastMessages.enterFirstName, duration: 1.0, position: .top)
            
        } else if !Validation_Model.validateWhiteSpace(lastName) {
            self.view.makeToast(ToastMessages.enterLastName, duration: 1.0, position: .top)
            
        } else if !Validation_Model.validateWhiteSpace(email) {
            self.view.makeToast(ToastMessages.enterEmail, duration: 1.0, position: .top)
            
        } else if !Validation_Model.validateWhiteSpace(password) {
            self.view.makeToast(ToastMessages.enterPassword, duration: 1.0, position: .top)
            
        } else if !Validation_Model.isValidEmail(testStr: email) {
            self.view.makeToast(ToastMessages.enterValidEmail, duration: 1.0, position: .top)
            
        } else if !Validation_Model.isValidPassword(passwordString: password) {
            self.view.makeToast(ToastMessages.enterValidPassword, duration: 1.0, position: .top)
            
        } else if !Validation_Model.isPwdMatchConfirmPwd(password: password, confirmPassword: confirmPassword) {
            self.view.makeToast(ToastMessages.passwordNotMatch, duration: 1.0, position: .top)
            
        } else {
            return true
        }
        return false
    }
}


//MARK: - Textfield delegate methods
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()

        }
        
        return true
    }
}
