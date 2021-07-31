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
    var arrayOfData      =     ["Home","Profile","Remainders","Log Out"]
    var isSideViewOpen   =     false
    
    //Mark: for search controller
    var searching        =     false
    var noteList         =     [Note]()
    var searchedItem     =     [NoteModel]()
    let searchController =   UISearchController(searchResultsController: nil)
    var collectionView: UICollectionView?
    
    var firstLoad        =      true
    var isListView       =      false
    var listView         =      UIBarButtonItem()
    var addButton        =      UIBarButtonItem()
    let uid              =      Auth.auth().currentUser?.uid
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //For Pagination
    
    let db              =      Firestore.firestore()
    var documents       =      [QueryDocumentSnapshot]()
    var modelArray      =      [NoteModel]()
    var size:Int?
    var query: Query!
    var lastSnapshot: QueryDocumentSnapshot!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkUserLoginWithFireBase()
        SideView.isHidden = true
        isSideViewOpen = false
        SideView.backgroundColor = .black
        SideBar.backgroundColor = .black
        
        title = "Notes"
        
        collectionView?.reloadData()
        configureViewController()
        configureSearchController()
        configureBarButton()
        guard let uid = Auth.auth().currentUser?.uid else{return print("Failed to acess uid")}
        query = db.collection("Notes").document(uid).collection("note").order(by: "title", descending: false).limit(to: 10 )
        calculateTotalData()
        //fetchData()
        //fetchNotes()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        print("In view will appear")
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        //testData()
        fetchNotes()
        // calculateTotalData()
         // fetchData()
    }
    func testData()
    {
        print("IN calculateTotalData..........Method")
        modelArray.removeAll()
        var query1 = db.collection("Notes").document(uid!).collection("note").order(by: "title", descending: false).limit(to: 10 )
        query1.getDocuments { QuerySnapshot,Error in
            if Error != nil{
                print("Error in fetching data")
            }
            else {
                QuerySnapshot!.documents.forEach({ (document) in
                    let data = document.data() as [String: AnyObject]
                    
                    let id = document.documentID
                   // print(id)
                    let title = data["title"] as? String ?? ""
                    let description = data["Description"] as? String ?? ""
                    
                    let newNote =  NoteModel(dictionary: ["title": title ,"Description": description,"id":id])
                    
                    
                    self.modelArray.append(newNote)
                    self.documents.insert(document, at: 0)
                    
                    
                })
                self.collectionView?.reloadData()
        
            }
        }

        
    }
    func calculateTotalData()
    {
        print("IN calculateTotalData..........Method")
        modelArray.removeAll()
        db.collection("Notes").document(Auth.auth().currentUser!.uid).collection("note").getDocuments { QuerySnapshot, Error in
            if Error != nil
            {
                print("Error in fetching data")
            }
            else
            {
                
                self.size = QuerySnapshot!.count
                self.fetchMoreData()
            }
        }
    }
    func fetchMoreData()
    {
        print("In FetchData Method .............")
        print(size)
        print(modelArray.count)
        if(modelArray.count < size ?? 0)
        {
            print("In fetchData")
            print(size)
            print("array count\(modelArray.count)")
            query.getDocuments { QuerySnapshot,Error in
                if Error != nil{
                    print("Error in fetching data")
                }
                else {
                    QuerySnapshot!.documents.forEach({ (document) in
                        let data = document.data() as [String: AnyObject]
                        
                        let id = document.documentID
                       // print(id)
                        let title = data["title"] as? String ?? ""
                        let description = data["Description"] as? String ?? ""
                        
                        let newNote =  NoteModel(dictionary: ["title": title ,"Description": description,"id":id])
                        
                        
                        self.modelArray.append(newNote)
                        self.documents.insert(document, at: 0)
                        
                        
                    })
                    self.collectionView?.reloadData()
                    
                    
                    
                }
            }
        }
        
    }
    func paginate()
    {
        print("In Pagination˳")
        query = query.start(afterDocument: documents.first!)
        fetchMoreData()
        
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
    let addImage = UIImage(systemName: "plus.app")
    let gridImage = UIImage(systemName: "rectangle.grid.2x2")
    let listImage = UIImage(systemName:  "list.dash")
    func configureBarButton()
    {
        
        addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(addButtonTapped))
        listView = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(listbuttonTapped))
        
        navigationItem.rightBarButtonItems = [addButton,listView]
        
        
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
    
    //Mark:- Fetch Mthods

    func fetchNotes()
    {
        modelArray.removeAll()
        DataBaseLayer.DBLayerManger.getNotes {  model in
            self.modelArray = model
            self.collectionView?.reloadData()
        }
        
        print(modelArray)
        
        
    }
    @objc func listbuttonTapped()
    {
        if isListView
        {
            print("******************")
            listView = UIBarButtonItem(image: listImage, style: .done, target: self, action: #selector(listbuttonTapped))
            isListView = false
        }
        else
        {
            listView = UIBarButtonItem(image: gridImage, style: .done, target: self, action: #selector(listbuttonTapped))
            isListView = true
        }
        
        self.navigationItem.setRightBarButtonItems([addButton, listView], animated: true)
        collectionView?.reloadData()
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
    
    //Mark:- Authentication code
    
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
        print("-----------------------------------------")
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
        else if indexPath.row == 2
        {
            let remainderVc = RemainderViewController()
//            let nav = UINavigationController(rootViewController: remainderVc)
//            present(nav, animated: true, completion: nil)
            self.navigationController?.pushViewController(remainderVc, animated: true)
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
            // return model.count
            return modelArray.count
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if( indexPath.row == modelArray.count-1 )
        {
            paginate()
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
            // thisNote = model[indexPath.row]
            thisNote = modelArray[indexPath.row]
            notecell.labell.text = thisNote.title
            notecell.label2.text = thisNote.description
        }
        
        
        
        return notecell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        //let note = noteList[indexPath.row]
        let selectedcell = modelArray[indexPath.row]
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
            
            aleart.textFields?[0].text = selectedcell.title
            aleart.textFields?[1].text = selectedcell.description
            
            aleart.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { _ in
                guard let field = aleart.textFields ,field.count == 2  else{
                    return
                }
                
                let newName = field[0].text
                let newDescription = field[1].text
                
                DataBaseLayer.DBLayerManger.updateNote(note: selectedcell, title: newName!, description: newDescription!)
                self.fetchNotes()
                
            }))
            
            
            self.present(aleart, animated: true, completion: nil)
            
            
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
          
            DataBaseLayer.DBLayerManger.deleteNote(note: selectedcell)
            //self.fetchNotes()
            self.testData()
            
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
        let heightVal = view.frame.height
        let widthVal = view.frame.width
        if !isListView
        {
            
            let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
            return CGSize(width: cellsize - 50   , height:  cellsize - 100 )
        }
        else
        {
            print(widthVal)
            return CGSize(width: widthVal-40, height: 120)
        }
        
        
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
            for item in modelArray
            {
                
                
                if item.title.lowercased().contains(searchText.lowercased()) == true || item.description.lowercased().contains(searchText.lowercased()) == true
                {
                    print(searchText)
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






