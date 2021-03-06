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
    var voteArray = [Int]()
    
    
    var movieVote = [Movie]()
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieVote.append(Movie(n: "kingsman", v: 0))
        
        do {
        let encoder = JSONEncoder()
        
        let d = try encoder.encode(movieVote)
        print("here")
        db.collection("names").document("movieArray").setData(["movies": d], merge: true) } catch {
            print("unable to encode class (\(error)")
        }
            
        setClassArray()
        setArray()
        
        textFieldOutlet.delegate = self
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        textFieldOutlet.resignFirstResponder()
        tableViewOutlet.reloadData()
        print("lol")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableViewOutlet.reloadData()
        
        infoListener = db.collection("names").document("movieArray").addSnapshotListener { (QuerySnapshot, err) in
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
        return movieVote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = movieVote[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
           // setArray()
//            movieArray.remove(at: indexPath.row)
//
//               voteArray.remove(at: indexPath.row)
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//            save()
            tableView.reloadData()
          
        }
    }
    @IBAction func addAction(_ sender: UIButton) {
        if textFieldOutlet.text != "" {
            
            movieVote.append(Movie(n: textFieldOutlet.text!, v: 0))
            movieSave()
            tableViewOutlet.reloadData()
            /*
            for simple array
            movieArray.append(textFieldOutlet.text!)
            print("first")
            voteArray.append(0)
            save()
            print("after")
            tableViewOutlet.reloadData() */
            
        }
        else {
            print("add failed")
        }
    }
    
    
    
    func setClassArray() {
        let docRef = db.collection("names").document("movieArray")
        
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let dataDescription = document.data()!
                var jerry = Data()
                
                if let temp = dataDescription["movies"] as? Data {
                    jerry = temp
                }
                
                
                
                do{
                    let decoder = JSONDecoder()
                    
                    self.movieVote = try decoder.decode([Movie].self, from: jerry)
                } catch {
                    print("unable to encode class ")
                }
            }
        }
    }
    
    
    
    func setArray() {
        let docRef = db.collection("names").document("MovieArray")
        
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let dataDescription = document.data()!
                
                
                if let jerry = dataDescription["movieNames"] {
                    if let jamal = jerry as? [String] {
                        self.movieArray = jamal
                        self.voteArray = dataDescription["votes"] as! [Int]
                    }
                    
                }
                
                else {
                    print("error when saving or nothing in firebase")
                }
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
    
    func save() {
        db.collection("names").document("MovieArray").setData(["movieNames": movieArray], merge: true)
        db.collection("names").document("MovieArray").setData(["votes": voteArray], merge: true)
    }
    
    func movieSave() {
        db.collection("names").document("movieArray").setData(["movie": movieVote], merge: true)
    }
}

