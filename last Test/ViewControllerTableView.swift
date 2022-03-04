//
//  ViewControllerTableView.swift
//  last Test
//
//  Created by DANIEL VEGA on 2/25/22.
//

import UIKit
import Firebase

public class StaticStuff {
    public static var mom = "mom"
}
class ViewControllerTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    let db = Firestore.firestore()
    
    var ref = Database.database().reference()

    var infoListener: ListenerRegistration!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var movieArray = [String]()
    
    
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setArray()
        textFieldOutlet.delegate = self
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        textFieldOutlet.resignFirstResponder()
        tableViewOutlet.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableViewOutlet.reloadData()
        
        infoListener = db.collection("names").document("array").addSnapshotListener { (QuerySnapshot, err) in
            if let err = err {
                print("error getting documents: \(err)")
            }
            else {
                self.setArray()
                let secondsToDelay = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    self.tableViewOutlet.reloadData()
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableViewOutlet.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = movieArray[indexPath.row]
        return cell
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        if textFieldOutlet.text != "" {
            movieArray.append(textFieldOutlet.text!)
            db.collection("names").document("array").setData(["movieList": movieArray], merge: false)
            tableViewOutlet.reloadData()
            
        }
        else {
            
        }
    }
    
    
    
    
    
    func setArray() {
        let docRef = db.collection("names").document("array")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                
                self.movieArray = dataDescription.first!.value as! [String]
                self.tableViewOutlet.reloadData()
                
            } else {
                print("Document does not exist")
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
       textFieldOutlet.resignFirstResponder()
        return true
    }
    
}
