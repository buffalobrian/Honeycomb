//
//  FirstViewController.swift
//  Honeycomb
//
//  Created by Niall Miner on 6/23/17.
//  Copyright © 2017 Niall Miner. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var cwidField: UITextField!
    @IBOutlet weak var requestField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!

    var nameString: String?, emailString: String?, phoneNumber: String?, CWID: String?, requestString: String?, dateObject: Date?
    
    var ref: DatabaseReference!
    
    @IBAction func submitButton(_ sender: Any) {
        // Get all input field values
        nameString = nameField.text
        emailString = emailField.text
        phoneNumber = phoneField.text
        CWID = cwidField.text
        requestString = requestField.text
        dateObject = dateField.date
        
        // Create connection w/ database & write to it
        ref = Database.database().reference()
        
        if nameString != "" && emailString != "" && phoneNumber != "" && CWID != "" && requestString != "" && dateObject != nil{
            let refreshAlert = UIAlertController(title: "Before You Submit", message: "You agree to the things yes?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Agree", style: .default, handler: { (action: UIAlertAction!) in
                let refaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                
                let blertController = UIAlertController(title: "Thanks, " + self.nameString! + "!", message: "We'll contact you at " + self.emailString! + " reminding you when to return our equipment", preferredStyle: .alert)
                
                //now we are adding the default action to our alertcontroller
                blertController.addAction(refaultAction)
                
                //and finally presenting our alert using this method
                self.present(blertController, animated: true, completion: nil)
                
                //Get Current Time and Add to DB
                let date = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
                let dateString = dateFormatter.string(from: date as Date)
                let returnDate = dateFormatter.string(from: self.dateObject! )
                self.ref.child("Check Out Forms/" + dateString).setValue(["name": self.nameString!, "email": self.emailString!, "phone": self.phoneNumber!, "CWID": self.CWID!, "RfR": self.requestString!, "Return By": returnDate])
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Disagree", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
            
        }
        else{
            let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            
            let alertController = UIAlertController(title: "Oops!", message: "It seems you did not fill in every field!", preferredStyle: .alert)
            
            //now we are adding the default action to our alertcontroller
            alertController.addAction(defaultAction)
            
            //and finally presenting our alert using this method
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameField.autocorrectionType = .no
        emailField.autocorrectionType = .no
        phoneField.autocorrectionType = .no
        cwidField.autocorrectionType = .no
        requestField.autocorrectionType = .no
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

