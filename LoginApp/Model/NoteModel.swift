//
//  Note.swift
//  LoginApp
//
//  Created by gadgetzone on 28/07/21.
//

import Foundation

struct NoteModel {
    //let id: String
    let title: String
    let description: String
    
    init(dictionary:[String:Any])
    {
        self.title = (dictionary["title"] as? String) ?? ""
        self.description =  (dictionary["Description"] as? String) ?? ""

    }
}

