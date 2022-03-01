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
    
    @IBOutlet weak var previous: UILabel!
    
    var inLabel = "default"
    
    let db = Firestore.firestore()
    
    var ref = Database.database().reference()
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        db.collection("names").document("docNames").setData(["jamal": inLabel], merge: false)
        
        let docRef = db.collection("names").document("docNames")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                self.previous.text = dataDescription
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
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

