//
//  customeLayer.swift
//  LoginApp
//
//  Created by gadgetzone on 28/07/21.
//

import Foundation
struct DataBaseLayer
{
     static let DBLayerManger = DataBaseLayer()
     let FireBaseManager = FireBaseManagament()
     let CoreDataManager = CoreDataOperation()
    
    func getNotes(complition: @escaping([NoteModel])-> Void)
    {
        FireBaseManager.getNotes { models in
            complition(models)
        }
    }
            
  
   
  public  func writeToFirebase(title: String, description: String)
  {
    FireBaseManager.writeToFirebase(title: title, description: description)
    CoreDataManager.saveNote(title: title, description: description)
       
  }
    
    

}
