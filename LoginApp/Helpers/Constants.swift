//
//  Constants.swift
//  LoginApp
//
//  Created by gadgetzone on 14/07/21.
//

import Foundation
import Firebase
import FirebaseAuth

struct Constants
{
    struct StoryBoard
    {
        static let homeViewController = "HomeVC"
        static let loginViewController = "LoginVC"
        static let signupViewController = "SignupVC"
        static let viewController = "VC"
        static let profileViewController = "profileVC"
        static let addViewController = "AddVC"
        static let RemainderViewController = "RemainderVC"
        
    }
    
    static let uid = Auth.auth().currentUser?.uid
}
