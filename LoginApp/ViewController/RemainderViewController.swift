//
//  RemainderViewController.swift
//  LoginApp
//
//  Created by gadgetzone on 30/07/21.
//

import UIKit

class RemainderViewController: UIViewController
{
    
    var titleForRemainder = UILabel()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureTextField()
       
        
    }
    func configureTextField()
    {
        view.addSubview(titleForRemainder)
        titleForRemainder.translatesAutoresizingMaskIntoConstraints = false
        titleForRemainder.text = "title"
        titleForRemainder.textColor = .black
        titleForRemainder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleForRemainder.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        titleForRemainder.widthAnchor.constraint(equalToConstant: 50).isActive = true
        titleForRemainder.heightAnchor.constraint(equalToConstant: 40).isActive = true
        

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
