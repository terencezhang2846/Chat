//
//  ChatViewController.swift
//  Chat
//
//  Created by Terence Zhang on 10/1/16.
//  Copyright © 2016 edu.usc.student.terencezhang. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    var chatObjects : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatObjects = NSArray();
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ChatViewController.refresh), userInfo: nil, repeats: true);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatObjects.count ?? 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("chatCell")!;
        let chat:PFObject = chatObjects[indexPath.row] as! PFObject;
        if let user = chat["user"] as? PFUser {
            cell.detailTextLabel?.text = user.username;
        }
        else {
            cell.detailTextLabel?.text = "????";
        }
        
        cell.textLabel?.text = chat["text"] as? String;
        return cell;
    }
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        let chat = PFObject(className: "Message_fbuJuly2016");
        chat["text"] = chatTextField.text;
        chat["user"] = PFUser.currentUser();
        chat.saveInBackgroundWithBlock { (success, error) in
            if(error == nil){
                print(chat["text"]);
            }
            else {
                let errorString = error!.userInfo["error"] as? String
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil);
            }
        }
        
    }
    func refresh(){
        let query = PFQuery(className: "Message_fbuJuly2016");
        query.includeKey("user");
        query.addDescendingOrder("createdAt");
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if(error == nil){
                self.chatObjects = objects
            }
            else{
                let errorString = error!.userInfo["error"] as? String
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil);
            }
        }
        
        self.tableView.reloadData();
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
