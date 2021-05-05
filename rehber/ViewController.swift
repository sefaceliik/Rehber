//
//  ViewController.swift
//  rehber
//
//  Created by Sefa MacBook Pro on 2.05.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //var dataPerson = PersonX()
    //var people = [PersonX]()
    var nameArray = [String]()
    var surnameArray = [String]()
    var birthdateArray = [String]()
    var emailArray = [String]()
    var codeArray = [String]()
    var phoneArray = [String]()
    var noteArray = [String]()
    var uuidArray = [UUID]()
    
    var searchedNames = [String]()
    
    var isSearching = false
    
    
    
    
    
    var selectedID: UUID?
    var chosenId : UUID?
    var chosenName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        addButton.layer.cornerRadius = addButton.frame.height / 3
        
        
        
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("NewPerson"), object: nil)
    }
    

    @IBAction func addButtonClicked(_ sender: Any) {
        
        chosenName = ""
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    @objc func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //people.removeAll()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        do{
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if let name = result.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                        print(name)
                    }
                    if let surname = result.value(forKey: "surname") as? String {
                        self.surnameArray.append(surname)
                    }
                    if let birthdate = result.value(forKey: "birthdate") as? String{
                        self.birthdateArray.append(birthdate)
                    }
                    if let email = result.value(forKey: "email") as? String {
                        self.emailArray.append(email)
                    }
                    if let code = result.value(forKey: "code") as? String {
                        self.codeArray.append(code)
                    }
                    if let phone = result.value(forKey: "phone") as? String {
                        self.phoneArray.append(phone)
                    }
                    if let note = result.value(forKey: "note") as? String{
                        self.noteArray.append(note)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.uuidArray.append(id)
                        print(id)
                    }
                    //people.append(dataPerson)
                    
                }
            }
            
        } catch{
            print("error")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailVC"{
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.selectedId = chosenId
            destinationVC.selectedName = chosenName
        }
        
    }
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return searchedNames.count
        } else {
            return nameArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as! HomeTableViewCell
    
        
        if isSearching{
            cell.nameLabel.text = searchedNames[indexPath.row]
        } else {
            //print(people[indexPath.row].nameOfPerson)
            cell.nameLabel.text = "\(nameArray[indexPath.row]) \(surnameArray[indexPath.row])"
            cell.birthdayLabel.text = birthdateArray[indexPath.row]
            cell.emailLabel.text = emailArray[indexPath.row]
            cell.phoneNumberLabel.text = "\(codeArray[indexPath.row]) \(phoneArray[indexPath.row])"
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenName = nameArray[indexPath.row]
        chosenId = uuidArray[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            // silme işlemi
            
            let idString = uuidArray[indexPath.row].uuidString
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0{
                    
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID{
                            context.delete(result)
                            nameArray.remove(at: indexPath.row)
                            surnameArray.remove(at: indexPath.row)
                            birthdateArray.remove(at: indexPath.row)
                            emailArray.remove(at: indexPath.row)
                            codeArray.remove(at: indexPath.row)
                            phoneArray.remove(at: indexPath.row)
                            noteArray.remove(at: indexPath.row)
                            uuidArray.remove(at: indexPath.row)
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                                
                            }
                             
                            do{
                                try context.save()
                            } catch{
                                print("error")
                            }
                        }
                    }
                }
            } catch{
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            isSearching = false
        } else{
            
            print(" Arama Sonucu : \(searchText)")
            isSearching = true
            searchedNames = nameArray.filter({$0.lowercased().contains(searchText.lowercased())})
        }
        
        tableView.reloadData()
    }
}
