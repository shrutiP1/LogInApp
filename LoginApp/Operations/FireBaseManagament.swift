//
//  File.swift
//  LoginApp
//
//  Created by gadgetzone on 26/07/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FireBaseManagament
{
    var model = [NoteModel]()
    var firebaseRef = Firestore.firestore().collection("Notes").document(Constants.uid!).collection("note")
    func getNotes(complition: @escaping([NoteModel])-> Void)
    {
        firebaseRef.getDocuments { snapshot, error in
            if let err = error{
                print("Error fetching docs: \(err)")
            }
            else
            {
                guard let snap = snapshot else {
                    return
                }
                self.model = snap.documents.map({
                    NoteModel(dictionary: $0.data())
                })
                print(self.model)
                complition(self.model)
            }
    }
            
  }
   
  public  func writeToFirebase(title: String, description: String)
  {
         print(title)
         print(description)
        let data:[String: Any] = ["title": title , "Description": description]
        guard let uid = Auth.auth().currentUser?.uid else { return print("Error in saving user id") }

         Firestore.firestore().collection("Notes").document(uid).collection("note").addDocument(data: data)
         
        //    let docRef = Firestore.firestore().document("Notes")
//    docRef.setData(["title":"Dadu"])
       
  }

}

