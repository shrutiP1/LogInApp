//
//  AddViewController.swift
//  LoginApp
//
//  Created by gadgetzone on 24/07/21.
//

import UIKit
import CoreData
protocol addNoteDelegate
{
    func addNote(title: String, description: String)
}
class AddViewController: UIViewController
{
    @IBOutlet weak var descTf: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    var delegate: addNoteDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
    }
    
    @objc func saveButtonTapped()
    {

        delegate?.addNote(title: titleTF.text!, description: descTf.text!)
        
        
        navigationController?.popViewController(animated: true)
        
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
