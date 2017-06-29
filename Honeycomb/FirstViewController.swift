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

    var nameString: String?, emailString: String?, phoneNumber: String?, CWID: Int?, requestString: String?
    
    var ref: DatabaseReference!
    
    @IBAction func submitButton(_ sender: Any) {
        // Get all input field values
        nameString = nameField.text
        emailString = emailField.text
        phoneNumber = phoneField.text
        
        // Create connection w/ database & write to it
        ref = Database.database().reference()
        
        //then we create a default action for the alert...
        //It is actually a button and we have given the button text style and handler
        //currently handler is nil as we are not specifying any handler
        let defaultAction = UIAlertAction(title: "Adios", style: .default, handler: nil)
        
        //It takes the title and the alert message and prefferred style
        if nameString != "" {
            let alertController = UIAlertController(title: "Thanks, " + nameString! + "!", message: "We'll contact you at " + emailString! + " reminding you when to return our equipment", preferredStyle: .alert)
            
            //now we are adding the default action to our alertcontroller
            alertController.addAction(defaultAction)
            
            //and finally presenting our alert using this method
            present(alertController, animated: true, completion: nil)
            
            //Get Current Time and Add to DB
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
            let dateString = dateFormatter.string(from: date as Date)
            self.ref.child("Check Out Forms/" + dateStrings).setValue(["name": nameString!, "email": emailString!, "phone": phoneNumber!])
            
        }
        else{
            let alertController = UIAlertController(title: "Oops!", message: "It seems you did not every field!", preferredStyle: .alert)
            
            //now we are adding the default action to our alertcontroller
            alertController.addAction(defaultAction)
            
            //and finally presenting our alert using this method
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

