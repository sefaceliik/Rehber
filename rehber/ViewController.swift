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
    
    
    // Arrays
    var nameArray = [String]()
    var surnameArray = [String]()
    var birthdateArray = [String]()
    var emailArray = [String]()
    var codeArray = [String]()
    var phoneArray = [String]()
    var noteArray = [String]()
    var uuidArray = [UUID]()
    
    
    // Section Vars
    var namesDict = [String : [String]]()
    var birthdateDict = [String : [String]]()
    var emailDict = [String : [String]]()
    var phoneNumberDict = [String : [String]]()
    var codeDict = [String : [String]]()
    var phoneDict = [String: [String]]()
    var nameSectionTitles = [String]()
    let indexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Ç", "Ş"]
    
    // Search Vars
    var searchedNames = [String]()
    var searchedSurnames = [String]()
    var indexHolder = [Int]()
    var isSearching = false
    
    
    // Segue Vars
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
        createNameDict()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("NewPerson"), object: nil)
    }
    
    
    
    
    
    func createNameDict(){
        for (index,name) in nameArray.enumerated(){
            
            let firstLetterIndex = name.index(name.startIndex, offsetBy: 1)
            let nameKey = String(name[..<firstLetterIndex])
            
            
            if var nameValues = namesDict[nameKey] {
                
                nameValues.append(name)
                namesDict[nameKey] = nameValues
                if var birthdateValues = birthdateDict[nameKey]{
                    
                    birthdateValues.append(birthdateArray[index])
                    birthdateDict[nameKey] = birthdateValues
                    
                    if var emailValues = emailDict[nameKey]{
                        
                        emailValues.append(emailArray[index])
                        emailDict[nameKey] = emailValues
                        
                        if var phoneNumberValues = phoneNumberDict[nameKey]{
                            
                            if var phoneValues = phoneDict[nameKey]{
                                
                                phoneValues.append(phoneArray[index])
                                phoneDict[nameKey] = phoneValues
                            }
                            
                            if var codeValues = codeDict[nameKey]{
                                
                                codeValues.append(codeArray[index])
                                codeDict[nameKey] = codeValues
                            }
                            
                        }
                    }
                }
            }else{
                namesDict[nameKey] = [name]
                birthdateDict[nameKey] = [birthdateArray[index]]
                emailDict[nameKey] = [emailArray[index]]
                codeDict[nameKey] = [codeArray[index]]
                phoneDict[nameKey] = [phoneArray[index]]
            }
            
        }
        
        nameSectionTitles = [String](namesDict.keys)
        nameSectionTitles = nameSectionTitles.sorted(by: { $0 < $1
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
                    
                }
            }
            
        } catch{
            print("error")
        }
        
        
        nameArray = bubbleSort(arr: nameArray)
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailVC"{
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.selectedId = chosenId
            destinationVC.selectedName = chosenName
        }
        
    }
    
    
    
    
    func bubbleSort (arr: [String]) -> [String]{
        
        var array = arr
        for _ in 0..<array.count-1{
            for j in 0..<array.count-1{
                
                if (array[j] > array[j+1]) {
                    
                    var temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                    
                    temp = surnameArray[j]
                    surnameArray[j] = surnameArray[j+1]
                    surnameArray[j+1] = temp
                    
                    temp = birthdateArray[j]
                    birthdateArray[j] = birthdateArray[j+1]
                    birthdateArray[j+1] = temp
                    
                    temp = emailArray [j]
                    emailArray[j] = emailArray[j+1]
                    emailArray[j+1] = temp
                    
                    temp = codeArray[j]
                    codeArray[j] = codeArray[j+1]
                    codeArray[j+1] = temp
                    
                    temp = phoneArray[j]
                    phoneArray[j] = phoneArray[j+1]
                    phoneArray[j+1] = temp
                    
                    temp = noteArray[j]
                    noteArray[j] = noteArray[j+1]
                    noteArray[j+1] = temp
                    
                    var tempo = uuidArray[j]
                    uuidArray[j] = uuidArray[j+1]
                    uuidArray[j+1] = tempo
                }
            }
        }
     
        return array
    }

  
}







// TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = nameSectionTitles.index(of: title) else { return -1 }
        
        return index
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nameSectionTitles[section]
    }
    
    
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if isSearching{
            return searchedNames.count
        } else {
            return nameArray.count
        }*/
        
        let nameKey = nameSectionTitles[section]
        guard let nameValues = namesDict[nameKey] else { return 0}
        
        return nameValues.count
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse") as! HomeTableViewCell
        
        var phoneNumber : String
        var code : String
    
        
        let nameKey = nameSectionTitles[indexPath.section]
        if let nameValues = namesDict[nameKey]{
            cell.nameLabel.text = nameValues[indexPath.row]
        }
        
        if let birthdateValues = birthdateDict[nameKey]{
            cell.birthdayLabel.text = birthdateValues[indexPath.row]
        }
        
        if let emailValues = emailDict[nameKey]{
            cell.emailLabel.text = emailValues[indexPath.row]
        }
        
        if let phoneValues = phoneDict[nameKey]{
            // phoneNumber = phoneValues[indexPath.row]
        }
        
        if let codeValues = codeDict[nameKey]{
            //code = codeValues[indexPath.row]
            //cell.phoneNumberLabel.text = "\(code) \(phoneNumber)"
        }
        
        
        
        
        /*if isSearching{
            cell.nameLabel.text = "\(nameArray[indexHolder[indexPath.row]]) \(surnameArray[indexHolder[indexPath.row]])"
            cell.birthdayLabel.text = birthdateArray[indexHolder[indexPath.row]]
            cell.emailLabel.text = emailArray[indexHolder[indexPath.row]]
            cell.phoneNumberLabel.text = "\(codeArray[indexHolder[indexPath.row]]) \(phoneArray[indexHolder[indexPath.row]])"
        } else {
            
            cell.nameLabel.text = "\(nameArray[indexPath.row]) \(surnameArray[indexPath.row])"
            cell.birthdayLabel.text = birthdateArray[indexPath.row]
            cell.emailLabel.text = emailArray[indexPath.row]
            cell.phoneNumberLabel.text = "\(codeArray[indexPath.row]) \(phoneArray[indexPath.row])"
            
        }*/
        
        
        
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
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }*/
}





// SearchBar
extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            isSearching = false
        } else{
            
            print(" Arama Sonucu : \(searchText)")
            isSearching = true
            searchedNames = nameArray.filter({$0.lowercased().contains(searchText.lowercased())})
            searchedSurnames = surnameArray.filter({$0.lowercased().contains(searchText.lowercased())})
            
            indexHolder.removeAll()
            var i = 0
            
            while i < nameArray.count {
                
                var j = 0
                while j < searchedNames.count {
                    
                    if  searchedNames[j] == nameArray[i]{
                        indexHolder.append(i)
                    }
                    
                    j = j + 1
                }
                
                i = i + 1
            }
        }
        
        tableView.reloadData()
    }
}


