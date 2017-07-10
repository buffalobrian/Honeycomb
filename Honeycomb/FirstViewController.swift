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

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var cwidField: UITextField!
    @IBOutlet weak var requestField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var myTableView: UITableView!

    var nameString: String?, emailString: String?, phoneNumber: String?, CWID: String?, requestString: String?, dateObject: Date?,
        newMedia: Bool?,
        equipmentLabels: [String] = [],
        availability: Bool?

    var ref: DatabaseReference!
    var refHandle: UInt!
    
    var searchActive : Bool = false
    var filtered:[String] = []
    
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
    
    
    ////////////////////////HANDLE SUBMIT BUTTON
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
    ////////////////////////END OF SUBMIT BUTTON
    
    ////////////////////////SEARCH BAR
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = equipmentLabels.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.myTableView.reloadData()
    }
    ////////////////////////END OF SEARCH BAR
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameField.autocorrectionType = .no
        emailField.autocorrectionType = .no
        phoneField.autocorrectionType = .no
        cwidField.autocorrectionType = .no
        requestField.autocorrectionType = .no
        
        searchBar.delegate = self
        
        //populate equipment array
        ref = Database.database().reference()
        refHandle = ref.child("EQUIPMENT").observe(DataEventType.value, with: { (snapshot) in
            let dataDict = snapshot.value as! [String: AnyObject]
            let group = DispatchGroup()
            for x in dataDict {
                group.enter()
                self.ref.child("EQUIPMENT").child(x.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let available = value?["available"] as? Bool
                    self.availability = available!
                    if available! {
                        self.equipmentLabels.append(x.key)
                        //print("Added an item to the inventory list: " + self.equipmentLabels.last!)
                        //print(self.equipmentLabels)
                    }
                    group.leave()
                })
            }
            
            //Reload tableView when the equipment array is finished
            group.notify(queue: .main) {
                print("All callbacks are completed")
                self.myTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ myTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return equipmentLabels.count
    }
    
    public func tableView(_ myTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FirstViewControllerTableViewCell
        
        if(searchActive){
            cell.myLabel.text = filtered[indexPath.row]
        } else {
            cell.myLabel.text = equipmentLabels[indexPath.row]
        }
        
        return cell
    }

}

