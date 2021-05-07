//
//  ViewController.swift
//  rehber
//
//  Created by Sefa MacBook Pro on 2.05.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    let toolbar = UIToolbar()
    
    
    
    
    
    // Section Vars
    var namesDict = [String : [PersonX]]()
    var nameSectionTitles = [String]()
    var searchedNamesDict = [String : [PersonX]]()
    var searchedNameSectionTitles = [String]()
    let indexTitles = ["#","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Ç", "Ş"]
    
    // Search Vars
    var searchedNames = [PersonX]()
    var isSearching = false
    
    
    // Segue Vars
    var chosenId : UUID?
    var chosenName = ""
    
    
    var people = [PersonX]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        addButton.layer.cornerRadius = addButton.frame.height / 3
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(doneButtonClicked))
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: true)
        
        searchBar.inputAccessoryView = toolbar
        
        
        getData()
        createNameDict()
        
    }
    
    @objc func doneButtonClicked(){
        
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("NewPerson"), object: nil)
    }
    
    
    
    func createNameDict(){
        for person in people{
            
            let firstLetterIndex = person.nameOfPerson!.index(person.nameOfPerson!.startIndex, offsetBy: 1)
            let nameKey = String(person.nameOfPerson![..<firstLetterIndex])
            
            
            if var nameValues = namesDict[nameKey] {
                
                nameValues.append(person)
                namesDict[nameKey] = nameValues
                
            }else{
                namesDict[nameKey] = [person]
            }
            
        }
        
        nameSectionTitles = [String](namesDict.keys)
        nameSectionTitles = nameSectionTitles.sorted(by: { $0 < $1
        })
    }
    
    func createSurnameDict(){
        for person in searchedNames{
            
            let firstLetterIndex = person.nameOfPerson!.index(person.nameOfPerson!.startIndex, offsetBy: 1)
            let nameKey = String(person.nameOfPerson![..<firstLetterIndex])
            
            
            if var nameValues = searchedNamesDict[nameKey] {
                
                nameValues.append(person)
                searchedNamesDict[nameKey] = nameValues
                
            }else{
                searchedNamesDict[nameKey] = [person]
            }
            
        }
        
        searchedNameSectionTitles = [String](searchedNamesDict.keys)
        searchedNameSectionTitles = searchedNameSectionTitles.sorted(by: { $0 < $1
        })
    }
    
    
    

    @IBAction func addButtonClicked(_ sender: Any) {
        
        chosenName = ""
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    
    
    
    
    @objc func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.returnsObjectsAsFaults = false
        
        
        do{
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                var counter = 0
                for result in results as! [NSManagedObject]{
                    
                    
                    let name = result.value(forKey: "name") as? String
                    let surname = result.value(forKey: "surname") as? String
                    let birthdate = result.value(forKey: "birthdate") as? String
                    let email = result.value(forKey: "email") as? String
                    let code = result.value(forKey: "code") as? String
                    let phone = result.value(forKey: "phone") as? String
                    let note = result.value(forKey: "note") as? String
                    let uuid = result.value(forKey: "id") as? UUID
                    
                    let newPerson : PersonX = try PersonX(name: name, surname: surname, birthdate: birthdate, email: email, code: code, phone: phone, note: note, id: uuid)
                    people.insert(newPerson, at: counter)
                    counter = counter + 1
                    people = people.sorted(by: { $0.nameOfPerson! < $1.nameOfPerson! })
                    
                
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







// TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        if isSearching{
            
            guard let index = searchedNameSectionTitles.index(of: title) else { return -1 }
            
            return index
            
        } else{
            
            guard let index = nameSectionTitles.index(of: title) else { return -1 }
            
            return index
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching{
            
            //return searchedNameSectionTitles.count
            return 1
        } else{
            
            return nameSectionTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isSearching{
            
            return searchedNameSectionTitles[section]
        } else{
            
            return nameSectionTitles[section]
        }
        
    }
    
    
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return indexTitles
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            
            /*let nameKey = searchedNameSectionTitles[section]
            guard let nameValues = searchedNamesDict[nameKey] else { return 0 }
            
            return nameValues.count*/
            return searchedNames.count
        } else {
 
            let nameKey = nameSectionTitles[section]
            guard let nameValues = namesDict[nameKey] else { return 0}
 
            return nameValues.count
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as! HomeTableViewCell
        
        
        if isSearching{
            
            
            if let name = searchedNames[indexPath.row].nameOfPerson{
                if let surname = searchedNames[indexPath.row].surnameOfPerson{
                    
                    cell.nameLabel.text = "\(name) \(surname)"
                }
            }
            if let birthdate = searchedNames[indexPath.row].birthdateOfPerson{
                
                cell.birthdayLabel.text = birthdate
            }
            if let email = searchedNames[indexPath.row].emailOfPerson{
                
                cell.emailLabel.text = email
            }
            if let code = searchedNames[indexPath.row].codeOfPerson{
                if let phone = searchedNames[indexPath.row].phoneOfPerson{
                    
                    cell.phoneNumberLabel.text = "\(code) \(phone)"
                }
            }
            if let note = searchedNames[indexPath.row].noteOfPerson{
                cell.noteField.text = note
            }
            
        } else{
            
            let nameKey = nameSectionTitles[indexPath.section]
            if let nameValues = namesDict[nameKey] {
                
                if let name = nameValues[indexPath.row].nameOfPerson{
                    if let surname = nameValues[indexPath.row].surnameOfPerson{
                        
                        cell.nameLabel.text = "\(name) \(surname)"
                    }
                }
                
                if let code = nameValues[indexPath.row].codeOfPerson{
                    if let number = nameValues[indexPath.row].phoneOfPerson{
                        
                        cell.phoneNumberLabel.text = "\(code) \(number)"
                    }
                }
                
                cell.birthdayLabel.text = nameValues[indexPath.row].birthdateOfPerson
                cell.emailLabel.text = nameValues[indexPath.row].emailOfPerson
                cell.noteField.text = nameValues[indexPath.row].noteOfPerson
                
            }
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let name = people[indexPath.row].nameOfPerson{
            chosenName = name
        }
        if let id = people[indexPath.row].idOfPerson{
            chosenId = id
        }
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            // silme işlemi
            
            let idString = people[indexPath.row].idOfPerson!.uuidString
            
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
                            
                            people.remove(at: indexPath.row)
                            
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
}





// SearchBar
extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchedNames.removeAll()
        if searchText == ""{
            isSearching = false
        } else{
            
            print(" Arama Sonucu : \(searchText)")
            isSearching = true
            
            for person in people{
                
                if person.nameOfPerson!.contains(searchText){
                    searchedNames.append(person)
                }
                
            }
            
            for person in people{
                
                if person.surnameOfPerson!.contains(searchText){
                    
                    if searchedNames.contains(person){
                        
                    } else{
                        searchedNames.append(person)
                    }
                    
                    
                }
                
            }
            searchedNames = searchedNames.sorted(by: { $0.nameOfPerson! < $1.nameOfPerson! })
            
        }
        
        tableView.reloadData()
    }
}


