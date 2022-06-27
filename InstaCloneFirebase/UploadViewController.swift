//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Burak Öztopuz on 14.06.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var selectImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        selectImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedImage))
        selectImage.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    @objc func selectedImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func makeAlert(titleInput : String, messageInput : String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }

 
    @IBAction func postButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFile = storageRef.child("media")
        let uuid = UUID().uuidString
        
        if let imgData = selectImage.image?.jpegData(compressionQuality: 0.5){
            let imageRef = mediaFile.child("\(uuid).jpg")
            imageRef.putData(imgData, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
//                            DataBase
                           
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreRef : DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageUrl, "postedBy" : Auth.auth().currentUser?.email, "postComment" : self.commentText.text, "date" : FieldValue.serverTimestamp() , "Like" : 0] as [String : Any]
                            
                            firestoreRef = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
                                }else{
                                    self.selectImage.image = UIImage(named: "cameraa.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            }
                            )

                     }
                    }
                }
            }
        }
    }
    
}
