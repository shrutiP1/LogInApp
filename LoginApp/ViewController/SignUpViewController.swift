//
//  SignUpViewController.swift
//  LoginApp
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
protocol addInfo
{
    func addInfoToDataBase(db: Firestore)
    
}
class SignUpViewController: UIViewController
{
    let db = Firestore.firestore()
      var delegate:addInfo?
    @IBOutlet weak var NavigationItem: UINavigationItem!
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PassWordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var ErrorButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        ErrorButton.numberOfLines = 3
        ErrorButton.lineBreakMode = .byWordWrapping
            
    }
    func application(_application: UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]?)->Bool
    {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        return true
    }

    func setUpElements()
    {
        //NavigationItem.backBarButtonItem = .none
        ErrorButton.alpha = 0;
        Utilities.styleTestField(textfield: FirstNameTextField)
        Utilities.styleTestField(textfield: LastNameTextField)
        Utilities.styleTestField(textfield: EmailTextField)
        Utilities.styleTestField(textfield: PassWordTextField)
        Utilities.stylefilledButton(_button: SignUpButton)
        
    }
    
   func vallidateFields() -> String?
   {
     //check that all fields fields in
    if FirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines ) == "" || (LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") || (EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") || (PassWordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
    {
        
        return "Please Fill In all Fields"
    }
    //Check if email is in correct formate
    
    let cleanedEmil = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if(Utilities.isEmailVallid(Email: cleanedEmil) == false)
    {
        return "Please Enter vallid Email-id"
    }
    //check if password is secure
    let cleanedPassword = PassWordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    if(Utilities.isPasswordVallid(_password: cleanedPassword) == false)
    {
        return "Please Make Sure your password is at least 8 character , contains a special character and a number "
    }
     
     return nil
   }
    @IBAction func SignUpTapped(_ sender: Any)
    {
        //vallidate the fields
       let error = vallidateFields()

        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            //create cleaned version of the data
            
            let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PassWordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the users
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //check for errors
                if err != nil
                {
                   self.showError(message: "Error creating user")
                }
                else
                {
                    
                    self.transitionToHome()
//                    self.delegate!.addInfoToDataBase(db: self.db)
//                    self.db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName,"uid":result!.user.uid]) { (error) in
//                        if error != nil{
//                            self.showError(message: "Error Savin User Data")
//                        }
//                        else
//                        {
//                            //transition to home screen
//                            self.transitionToHome()
//
//                        }
//                    }
                     
                }
            }
            
        }
    }
 
    
    func showError(message:String)
    {
        
        ErrorButton.text = message
        ErrorButton.alpha = 1
        
    }
    func transitionToHome()
    {
        let loginViewController =   storyboard?.instantiateViewController(identifier: Constants.StoryBoard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    

}

