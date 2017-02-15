//
//  FeedViewController.swift
//  AC3.2-Final
//
//  Created by Eric Chang on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var feedTableView: UITableView!
    var databaseReference: FIRDatabaseReference!
    var posts = [Post]()
    var images = [UIImage]()
    let gsReference = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com/images/")
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        
        self.feedTableView.estimatedRowHeight = 400.0
        self.feedTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Data Source
    func getPosts() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var newPosts: [Post] = []
            let storage = FIRStorage.storage()
            let storageRef = storage.reference()
            
            for child in snapshot.children {
                dump(child)
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String:String] {
                    
                    let spaceRef = storageRef.child("images/\(snap.key)")
                    
                    spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("Guarding against bad images. Error: \(error)")
                        }
                        else {
                            /**
                             * Developer Notes:
                             *   This should make loading the tableview must faster
                             *   For prepareForReuse, rather downloading again, we have it in [Posts]
                             *   Please let me know if this is bad practice or not
                             */
                            if let image = UIImage(data: data!) {
                            let link = Post(key: snap.key,
                                            comment: valueDict["comment"] ?? "",
                                            userId: valueDict["userId"] ?? "",
                                            image: image)
                            newPosts.append(link)
                            }
                            
                            self.posts = newPosts
                            self.feedTableView.reloadData()
                        }
                    }
                }
            }

        })
    }
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedTableViewCell
        cell.postImageView.image = nil
        
        let post = posts[indexPath.row]
        
        cell.postComment.text = post.comment
        
        cell.postImageView.image = post.image
        

        
        return cell
    }

    
    
}
