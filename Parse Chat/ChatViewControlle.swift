//
//  ChatViewControlle.swift
//  Parse Chat
//
//  Created by Hussain Almajed on 1/31/18.
//  Copyright © 2018 Hussain Almajed. All rights reserved.
//

import UIKit
import Parse

class ChatViewControlle: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    var messages: [PFObject] = []
     let query = PFQuery(className: "Message")
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        let chatMessage = PFObject(className: "Message")
        
        chatMessage["text"] = messageField.text
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                print(chatMessage)
                self.messageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    
            
            // Uses query to retrieve the objects from Messages table (notice “Objects" rather than “Object”) and returns both an array of PFObjects(messages) and an Error(error) when complete
        

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewControlle.onTimer), userInfo: nil, repeats: true)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
    
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 100
    
        //tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.messageLabel.text = messages[indexPath.row]["text"] as! String?
        
        if let user = messages[indexPath.row]["user"] {
            cell.userLabel.text = (user as! PFUser).username
        } else {
            cell.userLabel.text = "Anonymous User"
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
    }
    @objc func onTimer() {
        let query = PFQuery(className:"Message")
        query.includeKey("user")
       query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if error == nil {
                print("Successfully retrieved \(messages!.count) messages.")
                let messagesArray = messages!
                self.messages = messagesArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error?.localizedDescription)")
            }
            
        }

        // Add code to be run periodically
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
