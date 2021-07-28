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


class HomeViewController:UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    //Mark: IbOutlet
    @IBOutlet weak var SideBar: UITableView!
    @IBOutlet weak var SideView: UIView!
    var arrayOfData = ["Home","Profile","Settings","Log Out"]
    var isSideViewOpen = false
    
    //Mark: for search controller
    var searching = false
    var noteList = [Note]()
    var searchedItem = [NoteModel]()
    let searchController = UISearchController(searchResultsController: nil)
    var collectionView: UICollectionView?
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var firstLoad = true
    

    let uid = Auth.auth().currentUser?.uid
    var model = [NoteModel]()
    var firebaseRef = Firestore.firestore().collection("Notes").document(Constants.uid!).collection("note")
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkUserLoginWithFireBase()
        SideView.isHidden = true
        isSideViewOpen = false
        SideView.backgroundColor = .black
        SideBar.backgroundColor = .black
        
        title = "Notes"
        
        //fetchItem()
        
       collectionView?.reloadData()
        configureViewController()
        configureSearchController()
        fetchNotes()
    }

    func configureViewController()
    {
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
    
    func fetchItem()
    {
    
        DataBaseLayer.DBLayerManger.CoreDataManager.getallItems { noteList in
            self.noteList = noteList
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }

        
    }
    func fetchNotes()
    {
        DataBaseLayer.DBLayerManger.getNotes {  model in
            self.model = model
            self.collectionView?.reloadData()
        }

        print(model)
       

    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("------------------------------------------------")
        super.viewWillAppear(animated)
        fetchNotes()


    }
    @objc func addButtonTapped()
    {
                
        let navVc = (self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.addViewController) as? AddViewController)!
        
        navigationController?.pushViewController(navVc, animated: true)


    }
    
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
        if uid == nil
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
    
}
extension HomeViewController
{
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
            if uid != nil
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
}


extension HomeViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if searching
        {
            return searchedItem.count
        }
        else
        {
            return model.count
        }
   
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let notecell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomeCollectionViewCell.identifier, for: indexPath) as! CustomeCollectionViewCell
        let thisNote: NoteModel
        
        if searching
        {
            thisNote = searchedItem[indexPath.row]
            notecell.labell.text = thisNote.title
            notecell.label2.text = thisNote.description
        }
        else
        {
            thisNote = model[indexPath.row]
            notecell.labell.text = thisNote.title
            notecell.label2.text = thisNote.description
        }
        
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
            DataBaseLayer.DBLayerManger.CoreDataManager.updateNote(note: note, newTitle: newName!, newDescription: NewDescription!)
//            customeLayer.callForCoreData.updateNote(note: note, newTitle: newName!, newDescription: NewDescription!)
                self.fetchItem()


            }))


            self.present(aleart, animated: true, completion: nil)


        }))

        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            DataBaseLayer.DBLayerManger.CoreDataManager.deleteNote(note: note)
//            customeLayer.callForCoreData.deleteNote(note: note)
          //  self.callForCoreData.deleteNote(note: note)
            self.fetchItem()

        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(sheet, animated: true, completion: nil)
    }
    
   

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
                
                
                if item.title?.lowercased().contains(searchText.lowercased()) == true || item.desciption?.lowercased().contains(searchText.lowercased()) == true
                {
                    print(searchText)
                  //  searchedItem.append(item)
                    print("searched Item is for item \(searchedItem)")
                }
            }
            print(searchedItem)
        }
        else
        {
            searching = false
            searchedItem.removeAll()
           // searchedItem = noteList
        }
        collectionView?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedItem.removeAll()
        collectionView?.reloadData()
    }
    
    
    
    
}






