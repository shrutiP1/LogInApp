//
//  Note.swift
//  LoginApp
//
//  Created by gadgetzone on 28/07/21.
//

import Foundation
import Firebase

struct NoteModel {
    let id: String
    let title: String
    let description: String
    //let Date: NSDate
   // let created: Timestamp
    //let created:
    
    init(dictionary:[String:Any])
    {
        self.title = (dictionary["title"] as? String) ?? ""
        self.description =  (dictionary["Description"] as? String) ?? ""
        self.id = (dictionary["id"] as? String) ?? ""
      //  self.created = dictionary["created"] as? Timestamp ?? Timestamp(date: Date())

    }
}

