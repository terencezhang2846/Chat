//
//  LoginViewController.swift
//  Chat
//
//  Created by Terence Zhang on 10/1/16.
//  Copyright © 2016 edu.usc.student.terencezhang. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginPressed(sender: UIButton) {
   
        if !emailLabel.text!.isEmpty && !passwordLabel.text!.isEmpty {
            PFUser.logInWithUsernameInBackground(emailLabel.text!, password: passwordLabel.text!) { (user, error) -> Void in
                if error == nil {
                    self.performSegueWithIdentifier("login", sender: self);
                } else {
                    let errorString = error!.userInfo["error"] as? String
                    let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                        
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil);
                }
            }
        }
    }

    @IBAction func signupPressed(sender: AnyObject){
        let user = PFUser()
        user.username = emailLabel.text
        user.password = passwordLabel.text
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? String
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil);
            } else {
                self.performSegueWithIdentifier("login", sender: self);
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
