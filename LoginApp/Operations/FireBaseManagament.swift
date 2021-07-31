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

    
    func getNotes(complition: @escaping([NoteModel])-> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Notes").document(uid).collection("note").getDocuments { snapshot, error in
            if let err = error{
                print("Error fetching docs: \(err)")
            }
            else
            {

                self.model.removeAll()
                guard let snap = snapshot else {return }
                for document in snap.documents
             {
                    let id = document.documentID
                    let data = document.data()
                    let title = data["title"] as? String ?? ""
                    let description = data["Description"] as? String ?? ""
                    let created = data["created"] as? String ?? ""
                    let newNote =  NoteModel(dictionary: ["title": title ,"Description": description,"id":id])
                    
                    self.model.append(newNote)
             }
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
          
       
  }
    public func updateDataToFirebase(note:NoteModel , title: String, description: String)
    {
        print("In update method ")
        print(title)
        print(note)
        let data:[String: Any] = ["title": title , "Description": description]
        guard let uid  = Auth.auth().currentUser?.uid else {
            
            print("User is not vallid user")
            return
            
        }
        print(note.id)
        Firestore.firestore().collection("Notes").document(uid).collection("note").document(note.id).updateData(data) { error in
            if let error = error{
                print("Update Failed.......")
            }
            
        }
        
       
    }
    public func deleteDataToFirebase(note:NoteModel)
    {
        guard let uid = Constants.uid else{
            return
        }
        Firestore.firestore().collection("Notes").document(uid).collection("note").document(note.id).delete()
    }
   

}

