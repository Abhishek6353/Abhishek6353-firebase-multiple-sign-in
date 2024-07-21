//
//  LoginViewController.swift
//  LoginPro
//
//  Created by Abhishek on 21/07/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import CryptoKit
import AuthenticationServices

class LoginVC: UIViewController {
    
    var email = ""
    var password = ""
    fileprivate var currentNonce: String?

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
        let signUpVC = self.storyboard?.instantiateViewController(identifier: SignUpVC.className) as! SignUpVC
        AppDelegate.classInstance().mainNav.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func closeForgotViewClicked(_ sender: UIButton) {
        self.forgotView.isHidden = true
        self.forgotEmailTextfield.resignFirstResponder()
        self.forgotEmailTextfield.text = ""
    }
    
    @IBAction func forgotEmailSubmitClicked(_ sender: UIButton) {
        sendPasswordResentlink()
    }
    
    @IBAction func closeResendMailViewClicked(_ sender: UIButton) {
        self.resendEmailView.isHidden = true
    }
    
    @IBAction func resendEmailButtonclicked(_ sender: UIButton) {
        
    }
    
    @IBAction func signInWithGoogleButtonClicked(_ sender: UIButton) {
        signInWithGoogle()
    }
    
    @IBAction func signInWithAppleButtonClicked(_ sender: UIButton) {
        signInWithApple()
    }
    
    
    //MARK: - FUNCTION
    private func setupUIandTexts() {
        forgotView.isHidden = true
        resendEmailView.isHidden = true
    }
    
    private func login() {
        if isValidForLogin() {
            Utility.showLoadingView()
            
            Auth.auth().signIn(withEmail: email , password: password) { (result, error) in
                
                if let error = error
                {
                    self.view.makeToast(error.localizedDescription, duration: 1.0, position: .top)
                    Utility.hideLoadingView()
                    return
                }
                else
                {
                    Utility.hideLoadingView()
                    guard let _ = result?.user else { return }
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    self.redirectToHome()
                }
            }
        }
    }
    
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                self.showToast(message: "Google sign-in failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                self.showToast(message: "Something went wrong. PLease try again!")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Utility.showLoadingView()
            Auth.auth().signIn(with: credential) { result, error in
                Utility.hideLoadingView()
                
                if let error = error {
                    self.showToast(message: "Firebase sign-in failed: \(error.localizedDescription)")
                    return
                }
                
                guard let _ = result?.user else {
                    self.showToast(message: "Something went wrong. PLease try again!")
                    return
                }
                
                self.redirectToHome()
            }
        }
    }
    
    private func signInWithApple() {

        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

        
        
    
    private func sendPasswordResentlink() {
        
        if let email = forgotEmailTextfield.text {
            
            if !Validation_Model.validateWhiteSpace(email) {
                self.view.makeToast(ToastMessages.enterEmail, duration: 1.0, position: .top)
                return
            }
            
            if !Validation_Model.isValidEmail(testStr: email) {
                self.view.makeToast(ToastMessages.enterValidEmail, duration: 1.0, position: .top)
                return
            }
            
            
            Utility.showLoadingView()
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                
                if let error = error {
                    self.view.makeToast(error.localizedDescription, duration: 1.0, position: .top)
                    Utility.hideLoadingView()
                    return
                }
                else
                {
                    Utility.hideLoadingView()
                    self.view.makeToast(ToastMessages.resetPasswordLinkSent, duration: 1.0, position: .top)
                    
                    self.forgotView.isHidden = true
                    self.forgotEmailTextfield.resignFirstResponder()
                    self.forgotEmailTextfield.text = ""
                }
            }
        }
    }
    
    private func showToast(message: String) {
        self.view.makeToast(message, position: .top)
    }
    
    private func redirectToHome() {
        let homeVC = self.storyboard?.instantiateViewController(identifier: HomeVC.className) as! HomeVC
        AppDelegate.classInstance().mainNav.pushViewController(homeVC, animated: true)
        AppDelegate.classInstance().mainNav.topViewController?.view.makeToast(ToastMessages.loginSuccess)
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
extension LoginVC : UITextFieldDelegate {

    
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


extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else  {
            return UIWindow()
        }
        return window
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                Utility.hideLoadingView()
                
                if let error = error {
                    self.showToast(message: "Firebase sign-in failed: \(error.localizedDescription)")
                    return
                }
                
                guard let _ = authResult?.user else {
                    self.showToast(message: "Something went wrong. PLease try again!")
                    return
                }
                
                self.redirectToHome()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}
