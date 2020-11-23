//
//  LoginViewController.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/11/02.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import GoogleSignIn
import FirebaseUI

class AuthViewController: UIViewController {
    
    @IBOutlet weak var idTxField: UITextField!
    @IBOutlet weak var pwTxField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    private let disposeBag = DisposeBag()
    private var checkEmail : Bool?
    private var checkPassword: Bool?
    private var authResult : AuthDataResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        // GoogleSignInButton 생성
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // 로그인 창 생성하기 위한 코드
        let btnGoogleSignIn = GIDSignInButton()
        btnGoogleSignIn.style = .standard
        btnGoogleSignIn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnGoogleSignIn)
        
        NSLayoutConstraint.activate([
            btnGoogleSignIn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            btnGoogleSignIn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        ])
        
        
        self.idTxField
            .rx
            .text.orEmpty
            .subscribe(onNext: {
                (email) in
                self.checkEmail = self.checkEmailValid(email)
            }).disposed(by: self.disposeBag)
        
        self.pwTxField
            .rx.text.orEmpty
            .subscribe(onNext: {
                (password) in
                self.checkPassword = self.checkPasswordValid(password)
            }).disposed(by: self.disposeBag)
        
        
    }
    
    @IBAction func signInButtonTouched(_ sender: Any){
        Auth.auth().signIn(withEmail: idTxField.text!, password: pwTxField.text!){ [weak self] authResult, error in
            let vc = CalendarViewController()
            if authResult != nil{
                print("login success")
                self?.authResult = authResult
            }else{
                print("login fail")
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("shouldPerformSegue")
        if identifier == "loginSuccess" {
            guard let authResult = self.authResult else {return false}
            performSegue(withIdentifier: identifier, sender: sender)
            return true
        }else if identifier == "modalSignUp"{
            performSegue(withIdentifier: identifier, sender: sender)
            return true
        }
        return false
    }
    
    // MARK: SIGNUP Button touch up
//    @IBAction func signUpButtonTouched(_ sender: Any){
//        let emailSingUpView = EmailSignUpViewController()
//        self.present(emailSingUpView, animated: false, completion: {
//            print("Completed")
//        })
//    }
    
    // MARK: EMAIL VALID CHECK
    private func checkEmailValid(_ email: String) -> Bool {
        print("Check Email Valid")
        return email.contains("@") && email.contains(".")
    }

    // MARK: PASWORD VALID CHECK
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboard.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Google SignIn Delegate
extension AuthViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      // ...
        print("Google Login Success")
        self.performSegue(withIdentifier: "loginSuccess", sender: self)
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
