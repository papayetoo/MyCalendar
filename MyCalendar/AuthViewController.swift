//
//  LoginViewController.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/11/02.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseUI

class AuthViewController: UIViewController {
    
    @IBOutlet weak var idTxField: UITextField!
    @IBOutlet weak var pwTxField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
//    let googleSignInButton: GIDSignInButton = {
//        let button = GIDSignInButton()
//        button.style = .standard
//        button.addTarget(self, action: #selector GIDSignInButtonTouched(), for: .touchUpInside)
//        return button
//    }()
    
    var id : String?
    var pw : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // GoogleSignInButton 생성
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // 로그인 창 생성하기 위한 코드
        let btnGoogleSignIn = GIDSignInButton()
        btnGoogleSignIn.style = .standard
        btnGoogleSignIn.frame = CGRect(x:100, y: 100, width: 48, height: 48)
        self.view.addSubview(btnGoogleSignIn)
    }
    
    @IBAction func signInButtonTouched(_ sender: Any){
        Auth.auth().signIn(withEmail: idTxField.text!, password: pwTxField.text!){ (user, error) in
            let vc = CalendarViewController()
            if user != nil{
                print("login success")
            }else{
                print("login fail")
            }
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
        performSegue(withIdentifier: "goCalendar", sender: self)
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
