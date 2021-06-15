//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()

    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                //getdocuments method pulls docs from firebase database once all are loaded.  'addSnapshotListener' is used to regularly update latest messages, however it can be replaced with .getDocuments if you want to pull something from a database once (like a recipe?).  .Order advises the order the data should show up
            self.messages = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            // the above are Downcast as string as firebase can hold lots of different data types and we must advise what type of data we're getting.
                            
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async { //dispatch queue ensure that app doesn't hang while waiting to reload message data

                                self.tableView.reloadData() //trigger the datasource methods to reload the messages in the chat
                                
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                //indexPath is set as the amount of entries in the database, minusing one to account for position '0' in the array.
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        /*
         The below is what happens when the send button is pressed in the app:
         - messagebody and messageSender are determining what's been written into the text box in the chat, and who the logged in user is
         - db is initialising the current firestore under a constant
         - .collection.addDocument is adding whatever text has been written into the Firestore Database
         - K.FStore.collectionName is the name of the collection to add it to.  If no collection of that name exists then it'll create a new one instead.
         - K.FStore.senderField = "sender" & K.FStore.bodyField = "body" - these define the data inputs in the firestore database.  These can be set as anything.
         - The values uploaded are the messageBody and messageSender constants created in the initial 'if Let'
         - remember to choose the one with the error exception, and to hit enter on the box to generate the error handling closure and create the if let else error exception method as per the below
         */
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data:
                [K.FStore.senderField: messageSender,
                 K.FStore.bodyField: messageBody,
                 K.FStore.dateField: Date().timeIntervalSince1970
                    
                    
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving to firestore - \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
                
            }
            }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        //below code simplified from firebase webpage with no difference in functionality
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    //the UItableviewtablesource is the protocol that's responsible for populating the tableview - how
    //many cells it needs and what the content should be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        //this returns the amount of cells to populate within the table.  It has been set to the count of items within the message array so it continutes to increase as messages are created
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell // need to add as! Message Cell so cell correlates with the .xib created.  This only works once in viewDidLoad you initialise the MessageCell component
        cell.label.text = message.body
        
        //This is a message from the current user. setting the .Xib style
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true //Show the leftImage
            cell.rightImageView.isHidden = false //Show the rightImage
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false //Show the leftImage
            cell.rightImageView.isHidden = true //Show the rightImage
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }

        return cell
        //this determines what is in each cell that's been created.
    }
    
}


