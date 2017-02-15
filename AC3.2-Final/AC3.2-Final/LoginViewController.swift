//
//  LoginViewController.swift
//  AC3.2-Final
//
//  Created by Eric Chang on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Actions
    @IBAction func didPressLogin(_ sender: UIButton) {
        self.ref = FIRDatabase.database().reference()
        
        if let password = self.passwordTextField.text, let email = self.emailTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if user != nil {
                    
                    let alert = UIAlertController(title: "Login Successful.", message: nil, preferredStyle: .alert)
                    
                    func proceedHandler(actionTarget: UIAlertAction){
                        let transition: CATransition = CATransition()
                        transition.duration = 1.0
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionReveal
                        transition.subtype = kCATransitionFromBottom
                        self.view.window!.layer.add(transition, forKey: nil)
                        self.dismiss(animated: true, completion: nil)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let svc = storyboard.instantiateViewController(withIdentifier: "TabVC")
                        self.present(svc, animated: false, completion: nil)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: proceedHandler)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
        }
        
    }
    
    @IBAction func didPressRegister(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                
                if user != nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let svc = storyboard.instantiateViewController(withIdentifier: "TabVC")
                    self.present(svc, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    
    
}
