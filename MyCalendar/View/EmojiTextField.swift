//
//  EmojiTextField.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/11/23.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit

class EmojiTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override var textInputContextIdentifier: String? {""}
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes{
            if mode.primaryLanguage == "emoji"{
                return mode
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
               NotificationCenter.default.addObserver(self,
                                                      selector: #selector(inputModeDidChange),
                                                      name: UITextInputMode.currentInputModeDidChangeNotification,
                                                      object: nil)
    }
    
    @objc func inputModeDidChange(_ notification: Notification) {
       guard isFirstResponder else {return}
//       DispatchQueue.main.async { [weak self] in
//           self?.reloadInputViews()
//       }
    }
}
