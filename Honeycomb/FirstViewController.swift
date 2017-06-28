//
//  FirstViewController.swift
//  Honeycomb
//
//  Created by Niall Miner on 6/23/17.
//  Copyright © 2017 Niall Miner. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var cwidField: UITextField!
    @IBOutlet weak var requestField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!

    var nameString: String?, emailString: String?, phoneNumber: Int?, CWID: Int?, requestString: String?
    
    @IBAction func submitButton(_ sender: Any) {
        nameString = nameField.text
        emailString = emailField.text
        //It takes the title and the alert message and prefferred style
        let alertController = UIAlertController(title: "Thanks, " + nameString! + "!", message: "We'll contact you at " + emailString! + " reminding you when to return our equipment", preferredStyle: .alert)
        
        //then we create a default action for the alert...
        //It is actually a button and we have given the button text style and handler
        //currently handler is nil as we are not specifying any handler
        let defaultAction = UIAlertAction(title: "Adios", style: .default, handler: nil)
        
        //now we are adding the default action to our alertcontroller
        alertController.addAction(defaultAction)
        
        //and finally presenting our alert using this method
        present(alertController, animated: true, completion: nil)
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

