//
//  ViewController.swift
//  FireUpdater
//
//  Created by John Law on 8/5/2016.
//  Copyright © 2016 Chi Hon Law. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITextFieldDelegate {

    // Users info database address
    var ref = Firebase(url: "https://fireupdater.firebaseio.com/users")
    
    // Unique device id
    var device_id = UIDevice.currentDevice().identifierForVendor!.UUIDString


    @IBOutlet weak var first_name_field: UITextField!
    @IBOutlet weak var last_name_field: UITextField!
    @IBOutlet var hello_message: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delegate to textfile
        first_name_field.delegate = self
        last_name_field.delegate = self

        let userRef = ref.childByAppendingPath(device_id)

        userRef.observeEventType(.Value, withBlock: { data in
            if data.value is NSNull {
                // The value is null
            }
            else {
                // Get the data from the snap
                self.first_name_field.text = data.value.objectForKey("first_name") as? String
                self.last_name_field.text = data.value.objectForKey("last_name") as? String
                
                // Update hello message
                self.updateHelloMessage()
            }
        }, withCancelBlock: { error in
            // Indicate why the failure occurred
            print(error.description)
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Update user's name
    @IBAction func update(sender: AnyObject) {
        // Current user's directory
        let userRef = ref.childByAppendingPath(device_id)
        
        // Set user's info
        let users = ["first_name": first_name_field.text!, "last_name": last_name_field.text!]
        
        // Save the user's info
        userRef.setValue(users)
        
        // Update hello message
        self.updateHelloMessage()
    }

    // Delegate method for pressing "return" in UITextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    // Update hello message
    func updateHelloMessage() {
        // Get the full name of the user
        let full_name = first_name_field.text! + " " + last_name_field.text!

        // Update the message
        hello_message.text = "Hello " + full_name
    }
}

