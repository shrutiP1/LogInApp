//
//  HomeViewController.swift
//  LoginApp
//
//  Created by gadgetzone on 14/07/21.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseFirestore
import CoreData


class HomeViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,addInfo{
    
    
    //Mark: IbOutlet
    @IBOutlet weak var SideBar: UITableView!
    @IBOutlet weak var SideView: UIView!
    var models:[(title: String,note: String)] = []
    var arrayOfData = ["Home","Profile","Settings","Log Out"]
    var isSideViewOpen = false
    
    //Mark: for search controller
    var searching = false
    var searchedItem = [Note]()
    let searchController = UISearchController(searchResultsController: nil)
    var noteList = [Note]()
    let column: CGFloat = 2.0
    let inset:CGFloat = 8.0
    var collectionView: UICollectionView?
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var firstLoad = true
   // var callClass =  FireBaseManagament()
    
    let checkFireBaseLogin = Auth.auth().currentUser?.uid

    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkUserLoginWithFireBase()
        SideView.isHidden = true
        isSideViewOpen = false
        SideView.backgroundColor = .black
        SideBar.backgroundColor = .black
        title = "Notes"
        getallItems()
        FireBaseManagament.writeToFirebase()
   
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        collectionView.register(CustomeCollectionViewCell.self, forCellWithReuseIdentifier: CustomeCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.9836654067, green: 0.951574266, blue: 0.9674347043, alpha: 1)
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        configureSearchController()
    }
    func configureSearchController()
    {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Enter title to search"
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {   super.viewWillAppear(animated)
        getallItems()
        collectionView?.reloadData()
    }
    func getallItems()
    {

        print("this is get all function................... ")
               do {
                   noteList = try context.fetch(Note.fetchRequest())
                   DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                   }
               } catch  {
                   //error
               }
    }
    @objc func addButtonTapped()
    {
                
        let navVc = (self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.addViewController) as? AddViewController)!
        
        navVc.delegate = self
        
        navigationController?.pushViewController(navVc, animated: true)


    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if searching
        {
            return searchedItem.count
        }
        else
        {
            return noteList.count
        }
   
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let notecell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomeCollectionViewCell.identifier, for: indexPath) as! CustomeCollectionViewCell
        let thisNote: Note!
        
        if searching
        {
            thisNote = searchedItem[indexPath.row]
            notecell.labell.text = thisNote.title
            notecell.label2.text = thisNote.desciption
        }
        else
        {
            thisNote = noteList[indexPath.row]
            notecell.labell.text = thisNote.title
            notecell.label2.text = thisNote.desciption
        }
        
        notecell.layer.cornerRadius = notecell.frame.width/2
        notecell.contentView.layer.cornerRadius = 20
        notecell.contentView.layer.borderWidth = 1.0
        notecell.contentView.layer.borderColor = UIColor.black.cgColor
        notecell.contentView.layer.masksToBounds = true
        notecell.backgroundColor = UIColor.white
        notecell.layer.shadowColor = UIColor.gray.cgColor
        notecell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        notecell.layer.shadowRadius = 2.0
        notecell.layer.shadowOpacity = 1.0
        notecell.layer.masksToBounds = false
        notecell.layer.shadowPath = UIBezierPath(roundedRect: notecell.bounds, cornerRadius:notecell.contentView.layer.cornerRadius).cgPath
        return notecell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        let note = noteList[indexPath.row]
        print(indexPath.row)
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in

            let aleart = UIAlertController(title: "Edit Item", message: "Edit your Item", preferredStyle: .alert)
            aleart.addTextField{ field in
                field.placeholder = "Enter title here"


            }
            aleart.addTextField{ field in
                field.placeholder = "Enter Description here"

            }

            aleart.textFields?[0].text = note.title
            aleart.textFields?[1].text = note.desciption
         aleart.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { _ in
            guard let field = aleart.textFields ,field.count == 2  else{
                    return
                }
               let newName = field[0].text
               let NewDescription = field[1].text

            self.updateNote(note: note, newTitle: newName!, newDescription: NewDescription!)

            }))


            self.present(aleart, animated: true, completion: nil)


        }))

        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in

//            self.context.delete(note)
//            self.getallItems()
//            self.save()
            self.deleteNote(note: note)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(sheet, animated: true, completion: nil)
    }
    
   
    
    func saveNote(title: String, description: String)
    {
        
               
        print("***********************************")
              // let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
       
              // let newNote = Note(entity: entity!, insertInto: context)
               print(title)
               print(description)
               let newNote = Note(context: context)
//               newNote.id = Int32(noteList.count as NSNumber)
              newNote.title = title
              newNote.desciption = description
               
              //print(newNote)
        
             noteList.append(newNote)
            //self.addInfo(title: title, desc : description)
              self.save()
              
       

            
               
    }
    func save()
    {
        print("In save method..........")
        
        do
        {
            try context.save()
            print("In save method..........")
            collectionView?.reloadData()
        }
        catch
        {
            print("Context save error")
        }
    }
    func deleteNote(note:Note)
    {
        print("This is delete function ---------")
        self.context.delete(note)
        print("11111111111111")
        self.getallItems()
        print("22222222222222222222222")
        self.save()
    }
    func updateNote(note:Note,newTitle: String ,newDescription: String)
    {
        note.title = newTitle
        note.desciption = newDescription
        self.save()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        let destinationVC = segue.destination as! AddViewController
//
//        if let index =  collectionView?.indexPathsForSelectedItems
//        {
//            print(index)
//            //print(destinationVC.titleTF.text)
//        }
//
//    }
    
    
    


    //Mark: IBOutletFunctions
  
    @IBAction func menuBarButtonTapped(_ sender: UIButton)
    {
                SideBar.isHidden = false
                SideView.isHidden = false
                self.view.bringSubviewToFront(SideView)
                //self.view.bringSubviewToFront(sideBar)
                if !isSideViewOpen
                {
                    isSideViewOpen = true
                    SideView.frame = CGRect(x: 0, y: 88, width: 0, height: 808)
                    SideBar.frame = CGRect(x: 7, y: -14, width: 0, height: 800)
                    UIView.animate(withDuration: 0.3)
                    {
                        
                        self.SideView.frame = CGRect(x: 0, y: 88, width: 218, height: 808)
                        self.SideBar.frame = CGRect(x: 0, y: 0, width: 218, height: 800)
                    }
                 
                    
                    
                }
                else
                {
                    SideBar.isHidden =  true
                    SideView.isHidden = true
                    isSideViewOpen = false
                    SideView.frame = CGRect(x: 0, y: 88, width: 218, height: 808)
                    SideBar.frame = CGRect(x: 0, y: 0, width: 218, height: 800)
                    UIView.animate(withDuration: 0.3)
                    {
                        self.SideView.frame = CGRect(x: 0, y: 88, width: 0, height: 808)
                        self.SideBar.frame = CGRect(x: 7, y: -14, width: 0, height: 800)
                    }
                   
                    
                }
    }

    
    //Mark: Functions
//    override func viewWillAppear(_ animated: Bool)
//    {
//        self.navigationController?.isNavigationBarHidden = false
//
//
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let homeVC:HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.homeViewController) as! HomeViewController
            
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        else if indexPath.row == 1
        {
            
            let profileVC:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.profileViewController) as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        else if indexPath.row == 3
        {
            if checkFireBaseLogin != nil
            {
                let firebaseAuth = Auth.auth()
                do
                {
                    try firebaseAuth.signOut()
                    print("LogOut Successful From Firebase")
                    presentLogInScreen()
                }catch let error as NSError
                {
                    print("Error signing out: %@",error)
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.labelInTableView.text = arrayOfData[indexPath.row]

        return cell;

    }
    func checkUserIsLogin()
    {
        if AccessToken.current == nil
        {
            presentLogInScreen()
        }
    
    }
    
    func checkUserLoginWithFireBase()
    {
        print("*********************************")
        if checkFireBaseLogin == nil
        {
            presentLogInScreen()
        }
    }
    func presentLogInScreen()
    {
        let _: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.viewController) as! ViewController
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
        
    }
    
    var noteTitle: String?
    var noteDescription: String?
    func addInfo(title: String, desc: String)
    {
        print("In addInfo method")
        noteTitle = title
        noteDescription = desc
        saveDataToFireaBase()
    }
    func saveDataToFireaBase()
    {
        print("In saveDataMethod")
        let database = Firestore.firestore()
        let docref = database.document("Notes")
        docref.setData(["title":noteTitle])
    }
//        func saveInfoToDataBase(DB: Firestore)
//    {
//        print("**********************aaaaa")
//        database = DB
//    }
    func addInfoToDataBase(db: Firestore) {
       // saveInfoToDataBase(DB: db)
    }
    
//    func addInfoToDataBase(db: Firestore)
//    {
//        saveInfoToDataBase(DB: db)
//    }

   

}



extension HomeViewController: UICollectionViewDelegateFlowLayout
{
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 20, left: 20, bottom: 5, right: 20)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
        
            let bounds = collectionView.bounds
            let heightVal = self.view.frame.height
            let widthVal = self.view.frame.width
            let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
            return CGSize(width: cellsize-50 , height:  cellsize-100)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
    
}
extension HomeViewController: addNoteDelegate
{
    func addNote(title: String, description: String) {
         saveNote(title: title, description: description)
    }
    
}

extension HomeViewController: UISearchResultsUpdating,UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty
        {
            //searchText.lowercased())
            searching = true
            searchedItem.removeAll()
            print("searched item\(searchedItem)")
            for item in noteList
            {
                print(item.title)
//                if ((item.title?.lowercased().contains(searchText.lowercased())) != nil)
                
                if item.title?.lowercased().contains(searchText.lowercased()) == true || item.desciption?.lowercased().contains(searchText.lowercased()) == true
                {
                    print(searchText)
                    print("11111111111111111111111111111111111111")
                    searchedItem.append(item)
                    print("searched Item is for item \(searchedItem)")
                }
            }
            print(searchedItem)
        }
        else
        {
            searching = false
            searchedItem.removeAll()
            searchedItem = noteList
        }
        collectionView?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedItem.removeAll()
        collectionView?.reloadData()
    }
    
    
    
    
}






