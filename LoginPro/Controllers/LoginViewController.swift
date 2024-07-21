//
//  LoginViewController.swift
//  LoginPro
//
//  Created by Abhishek on 21/07/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var email = ""
    var password = ""
    
    //MARK: - OUTLET    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var loginCredentialsView: UIView!
    @IBOutlet weak private var hideShowPasswordImageView: UIImageView!
    @IBOutlet weak private var hideShowPasswordButton: UIButton!
    @IBOutlet weak private var forgotButton: UIButton!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var signUpButton: UIButton!
    @IBOutlet weak var forgotView: UIView!
    @IBOutlet weak var forgotRoundCornerView: UIView!
    @IBOutlet weak var resendEmailView: UIView!
    @IBOutlet weak var resendEmailRoundedCornerView: UIView!
    @IBOutlet weak var forgotEmailTextfield: UITextField!

    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        forgotEmailTextfield.delegate = self
        
        setupUIandTexts()
        
    }
    
    
    //MARK: - ACTION
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        login()
    }
    
    @IBAction func hideShowPasswordClicked(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
        hideShowPasswordImageView.image = sender.isSelected ? UIImage(named: "ic_hide_password") : UIImage(named: "ic_show_password")
    }
    
    @IBAction func forgotButtonClicked(_ sender: UIButton) {
        self.forgotView.isHidden = false
        self.forgotEmailTextfield.becomeFirstResponder()
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func closeForgotViewClicked(_ sender: UIButton) {
        self.forgotView.isHidden = true
        self.forgotEmailTextfield.resignFirstResponder()
        self.forgotEmailTextfield.text = ""
    }
    
    @IBAction func forgotEmailSubmitClicked(_ sender: UIButton) {

    }
    
    @IBAction func closeResendMailViewClicked(_ sender: UIButton) {
        self.resendEmailView.isHidden = true
    }
    
    @IBAction func resendEmailButtonclicked(_ sender: UIButton) {
        
    }
    
    
    
    //MARK: - FUNCTION
    
    private func setupUIandTexts() {
        forgotView.isHidden = true
        resendEmailView.isHidden = true
    }
    
    private func login() {
        
        if isValidForLogin() {

        }
    }
    
    
    private func sendPasswordResentlink() {
        
    }
    
    private func isValidForLogin() -> Bool {
        
        email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        password = passwordTextField.text ?? ""
        
        if !Validation_Model.validateWhiteSpace(email)
        {
            self.view.makeToast(ToastMessages.enterEmail, duration: 1.0, position: .top)
        }
        else if !Validation_Model.isValidEmail(testStr: email)
        {
            self.view.makeToast(ToastMessages.enterValidEmail, duration: 1.0, position: .top)
        }
        else if !Validation_Model.validateWhiteSpace(password)
        {
            self.view.makeToast(ToastMessages.enterPassword, duration: 1.0, position: .top)
        }
        else if !Validation_Model.isValidPassword(passwordString: password)
        {
            self.view.makeToast(ToastMessages.enterValidPassword, duration: 1.0, position: .top)
        }
        else
        {
            return true
        }
        return false
    }

}

//MARK: - UITextField Delegate

extension LoginViewController : UITextFieldDelegate {

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            login()
        } else if textField == forgotEmailTextfield {
            forgotEmailTextfield.resignFirstResponder()
            sendPasswordResentlink()
        }
        
        
        return true
    }
}
