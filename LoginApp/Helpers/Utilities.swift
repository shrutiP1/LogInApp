//
//  Utilities.swift
//  LoginApp
//
//  Created by gadgetzone on 14/07/21.
//

import Foundation
import UIKit
class Utilities
{
    static func styleTestField(textfield:UITextField)
    {
      let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
      bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
       textfield.borderStyle = .none
       textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func stylefilledButton(_button:UIButton)
    {
        _button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        
        _button.layer.cornerRadius = 25.0
        
        _button.tintColor = UIColor.white
    }
    
    static func styleholloButton(_button:UIButton)
    {
        _button.layer.borderWidth = 2
        _button.layer.borderColor = UIColor.black.cgColor
        _button.layer.cornerRadius = 25.0
        _button.tintColor = UIColor.black
    }
    
    static func isPasswordVallid(_password:String)->Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@#!%*?&])[A-Za-z\\d$@#!%*?&]{8,}")
        return passwordTest.evaluate(with: _password)
        
    }
    static func isEmailVallid(Email:String)->Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES%@", emailRegEx)
        return emailTest.evaluate(with: Email)
    }
    
}
