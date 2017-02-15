//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Eric Chang on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadTextField: UITextView!
    var databaseReference: FIRDatabaseReference!
    var selectedImage: UIImage?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadTextField.layer.borderWidth = 1.0
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickAnImage)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Image Picker Controller & Delegate
    func pickAnImage() {
        let picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.uploadImageView.image = info["UIImagePickerControllerOriginalImage"] as! UIImage?
        self.uploadImageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        self.selectedImage = uploadImageView.image
    }
    
    // MARK: - Actions
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        
        let user = FIRAuth.auth()?.currentUser
        let postRef = self.databaseReference.childByAutoId()
        
        if user?.uid != nil, let image = self.selectedImage {
            
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://ac-32-final.appspot.com")
            let spaceRef = storageRef.child("images/\(postRef.key)")
            
            let jpeg = UIImageJPEGRepresentation(image, 0.5)
            
            let metadata = FIRStorageMetadata()
            metadata.cacheControl = "public,max-age=300";
            metadata.contentType = "image/jpeg";
            
            let task = spaceRef.put(jpeg!, metadata: metadata) { (metadata, error) in
                guard metadata != nil else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                
            }
            
            let _ = task.observe(.progress, handler: { (snapshot) in
                let progress = Float((snapshot.progress?.fractionCompleted)!)
                print(progress)
                /**
                 *  Developer Notes:
                 *      .progress does not always reach 1.0
                 *       - Will still be uploaded, console print:
                 *          "Object images/-Kd2g59vM2ZMJtyBR0wE does not exist."
                 */
                if progress > 0.0 {
                    let alert = UIAlertController(title: "Photo Uploaded!", message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.tabBarController?.selectedIndex = 0
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            })
            
            let link = Post(key: postRef.key, comment: self.uploadTextField.text, userId: (user?.uid)!)
            let dict = link.asDictionary
            
            // put in the database
            postRef.setValue(dict) { (error, reference) in
                if let error = error {
                    print(error)
                }
                else {
                    print(reference)
                }
            }
        }
    }
    
    
    
    
}
