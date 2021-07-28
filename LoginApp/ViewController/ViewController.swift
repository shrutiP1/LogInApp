//
//  ViewController.swift
//  LoginApp
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController{
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
      override func viewDidLoad() {
        super.viewDidLoad()
        assignbackgroundImage()
        view.backgroundColor = UIColor.black
        setUpElement()
                    
        
      // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func assignbackgroundImage(){
           
           let background = UIImage(named: "4.png")
           var imageView : UIImageView!
           imageView = UIImageView(frame: view.bounds)
           imageView.contentMode =  UIView.ContentMode.scaleAspectFill
           imageView.clipsToBounds = true
           imageView.image = background
           imageView.center = view.center
           view.addSubview(imageView)
           self.view.sendSubviewToBack(imageView)
       }

    func setUpElement()
    {
        Utilities.stylefilledButton(_button: SignUpButton)
        Utilities.stylefilledButton(_button:LoginButton )
    }
    
    
    @IBAction func SignUpTap(_ sender: UIButton) {
        print("In signup tapped function")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let sc = storyBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignUpViewController
        
        
        print("......................")
        

        navigationController?.pushViewController(sc, animated: true)
    }
    
    @IBAction func SignUpTapped(_ sender: Any)
    {
        
      
        
        
        
    }
    @IBAction func LoginTapped(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.loginViewController) as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }


}

