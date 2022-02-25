//
//  ViewController.swift
//  last Test
//
//  Created by DANIEL VEGA on 2/24/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var testTextField: UITextField!
    
    @IBOutlet weak var helloWorldLabel: UILabel!
    
    var inLabel = "default"
    
    let db = Firestore.firestore()
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("names").document("docNames").setData(["jamal": inLabel], merge: false)
        
    }

    @IBAction func saveAction(_ sender: UIButton) {
        if testTextField.text != "" {
            inLabel = testTextField.text!
            db.collection("names").document("docNames").setData(["jamal": inLabel], merge: true)
            db.collection("names").document("docNames").setData(["jerry": "test"], merge: true)
        }
        else {
            
        }
    }
    
    
}

