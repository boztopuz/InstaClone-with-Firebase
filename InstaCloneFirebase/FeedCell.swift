//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Burak Öztopuz on 16.06.2022.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {

    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButton(_ sender: Any) {
        let firestoreDB = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!){
            let likeStore = ["Like" : likeCount + 1] as [String : Any]
            firestoreDB.collection("Posts").document(idLabel.text!).setData(likeStore, merge: true)
        }
    }
}
