//
//  CoreData.swift
//  LoginApp
//
//  Created by gadgetzone on 26/07/21.
//

import Foundation
import CoreData
import Firebase

class CoreDataOperation
{
    var noteList = [Note]()
    let context: NSManagedObjectContext = ( UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    static var callForCoreData = CoreDataOperation()
//    static var callForFirebase =  FireBaseManagament()

    func getallItems(complition: @escaping([Note])-> Void)
    {

        print("this is get all function................... ")
               do {
                   noteList = try context.fetch(Note.fetchRequest())
                   complition(noteList)
               } catch  {
                   
               }
    }
    func saveNote(title: String, description: String)
    {
          let newNote = Note(context: context)
             newNote.title = title
              newNote.desciption = description
               
             noteList.append(newNote)
              self.save()
//        DataBaseLayer.DBLayerManger.writeToFirebase(title: title, description: description)
//        customeLayer.callForFirebase.writeToFirebase(title: title, description: description)
            
            

    }
    func save()
    {
        do
        {
            try context.save()
            
        }
        catch
        {
            print("Context save error")
        }
    }
    func deleteNote(note:Note)
    {
        
        self.context.delete(note)
         self.save()
    }
    func updateNote(note:Note,newTitle: String ,newDescription: String)
    {
        note.title = newTitle
        note.desciption = newDescription
        self.save()
    }

}


