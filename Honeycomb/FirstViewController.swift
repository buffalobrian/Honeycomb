//
//  FirstViewController.swift
//  Honeycomb
//
//  Created by Niall Miner on 6/23/17.
//  Copyright © 2017 Niall Miner. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var cwidField: UITextField!
    @IBOutlet weak var requestField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!

    @IBOutlet weak var cameraImage: UIImageView!
    
    var nameString: String?, emailString: String?, phoneNumber: String?, CWID: String?, requestString: String?, dateObject: Date?,
        newMedia: Bool?
    
    var ref: DatabaseReference!
    
    ///////////////////BEGIN CAMERA FUNCTIONS
    @IBAction func camera_onClick(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = true
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            cameraImage.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    ////////////////////////END OF CAMERA FUNCTIONS
    
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

