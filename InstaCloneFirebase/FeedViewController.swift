//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Burak Öztopuz on 14.06.2022.
//

import UIKit
import FirebaseFirestore
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var tableView: UITableView!
    var userArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var imgUrlArray = [String]()
    var documentIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getDataFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.userLabel.text = userArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.imgView.sd_setImage(with: URL(string: self.imgUrlArray[indexPath.row]))
        cell.idLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    func makeAlert(titleInput : String , messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDataFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "ERROR!")
            }else{
                if snapshot?.isEmpty != true {
                    self.userArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.imgUrlArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userArray.append(postedBy)
                        }
                        if let comment = document.get("postComment") as? String {
                            self.commentArray.append(comment)
                        }
                        if let likes = document.get("Like") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imgUrl = document.get("imageUrl") as? String {
                            self.imgUrlArray.append(imgUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    

}
