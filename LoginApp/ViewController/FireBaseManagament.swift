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
    
  public static func writeToFirebase()
  {
    Firestore.firestore().collection("Notes").addDocument(data: ["Title":"Shruti"])
//    let docRef = Firestore.firestore().document("Notes")
//    docRef.setData(["title":"Dadu"])
    print(Auth.auth().currentUser?.uid)
  }
}
