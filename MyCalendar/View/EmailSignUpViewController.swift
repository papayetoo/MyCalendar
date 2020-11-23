//
//  emailSignInViewController.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/11/14.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit

class EmailSignUpViewController: UIViewController {
    
    init(){
        super.init(nibName: nil, bundle: nil)
        print("create EmailSingUpViewController super.init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("create EmailSingUpViewController by code")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("Email Sign In View")
    }
}
