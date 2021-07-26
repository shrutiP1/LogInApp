//
//  LoginViewController.swift
//  LoginApp
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController, LoginButtonDelegate{
    
    
    @IBOutlet weak var btn_facebook: FBLoginButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
   
    @IBAction func LoginButtonTapped(_ sender: Any)
    {
        print("***************************")
        let error = vallidateDetails()
        
        let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil
            {
                self.ErrorLabel.text = error!.localizedDescription
                self.ErrorLabel.alpha = 1
            }
            else
            {
                self.dismiss(animated: true, completion: nil)

            }
      }
    }
    @IBOutlet weak var ErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
            btn_facebook.permissions = ["public_profile", "email"]
            btn_facebook.delegate = self
        
        
    }
    
    func setUpElement()
    {
        ErrorLabel.alpha = 0;
        Utilities.styleTestField(textfield: EmailTextField)
        Utilities.styleTestField(textfield: PasswordTextField)
        Utilities.stylefilledButton(_button: LoginButton)
    }

        
    func vallidateDetails()->String?
    {
        if(EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") || (PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            return "Please Enter Both Email and Password"
        }
        
        return nil
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?)
    {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.homeViewController) as? HomeViewController

         view.window?.rootViewController = homeViewController
         view.window?.makeKeyAndVisible()

        print("you logged in")
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton)
    {
        print("you logged out")
    }
        
    

    
    
}



