//
//  DetailViewController.swift
//  rehber
//
//  Created by Sefa MacBook Pro on 3.05.2021.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {

    // Views
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var surnameView: UIView!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var noteView: UIView!
    
    // Labels
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var surnameErrorLabel: UILabel!
    @IBOutlet weak var birthdayErrorLabel: UILabel!
    @IBOutlet weak var mailErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var noteErrorLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // TexFields
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    // Others
    let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted
    var selectedCountry : String?
    var listOfCountryCodes = ["+90","+1"]
    var selectedName = ""
    var selectedId : UUID?
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        phoneNumberField.delegate = self
        
        viewSetting()
        createDatePicker()
        createPickerView()
        dissmissClosePickerView()
        
        if selectedName != ""{
            // take data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            let idString = selectedId!.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        
                        if let name = result.value(forKey: "name") as? String{
                            nameField.text = name
                        }
                        if let surname = result.value(forKey: "surname") as? String{
                            surnameField.text = surname
                        }
                        if let birthdate = result.value(forKey: "birthdate") as? String{
                            birthdayField.text = birthdate
                        }
                        if let email = result.value(forKey: "email") as? String{
                            emailField.text = email
                        }
                        if let code = result.value(forKey: "code") as? String{
                            codeField.text = code
                        }
                        if let phone = result.value(forKey: "phone") as? String{
                            phoneNumberField.text = phone
                        }
                        if let note = result.value(forKey: "note") as? String{
                            notesField.text = note
                        }
                    }
                }
                
            } catch{
                print("error")
            }
            
            
        } else {
            // add data
        }
        
    }
    
    
    
    func savingCoreData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        var newNumber = ""
        
        
        
        
        newPerson.setValue(nameField.text!.capitalizingFirstLetter(), forKey: "name")
        newPerson.setValue(surnameField.text!.capitalizingFirstLetter(), forKey: "surname")
        newPerson.setValue(birthdayField.text, forKey: "birthdate")
        newPerson.setValue(emailField.text, forKey: "email")
        newPerson.setValue(codeField.text, forKey: "code")
        newPerson.setValue(phoneNumberField.text, forKey: "phone")
        newPerson.setValue(notesField.text, forKey: "note")
        newPerson.setValue(UUID(), forKey: "id")
    
        do {
            try context.save()
            print("saving successful")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewPerson"), object: nil )
            performSegue(withIdentifier: "toSuccessVC", sender: nil)
        } catch{
            print("error")
        }
    }
    
    
    
    
    
    // UIButton Functions
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
       
        nameValidation()
        
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let numbers = "1234567890"
        let numbersSet = CharacterSet(charactersIn: numbers)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return numbersSet.isSuperset(of: typedCharacterSet)
    }
    
    // UIObjects Settings
    func viewSetting(){
        
        nameErrorLabel.isHidden = true
        surnameErrorLabel.isHidden = true
        birthdayErrorLabel.isHidden = true
        mailErrorLabel.isHidden = true
        phoneErrorLabel.isHidden = true
        noteErrorLabel.isHidden = true
        
        nameView.layer.cornerRadius = nameView.frame.height / 8
        surnameView.layer.cornerRadius = surnameView.frame.height / 8
        birthdayView.layer.cornerRadius = birthdayView.frame.height / 8
        emailView.layer.cornerRadius = emailView.frame.height / 8
        phoneView.layer.cornerRadius = phoneView.frame.height / 8
        noteView.layer.cornerRadius = noteView.frame.height / 8
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        backButton.layer.cornerRadius = backButton.frame.height / 3
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButton.bounds
        gradientLayer.colors = [UIColor.systemPurple.cgColor,
                                UIColor.systemIndigo.cgColor,]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = gradientLayer.frame.height / 2
        saveButton.layer.addSublayer(gradientLayer)
        
        
        
    }
    
    func defaultBorderWidth(){
        nameView.layer.borderWidth = 0
        surnameView.layer.borderWidth = 0
        emailView.layer.borderWidth = 0
        phoneView.layer.borderWidth = 0
        birthdayView.layer.borderWidth = 0
        noteView.layer.borderWidth = 0
    }
}


// Picker Functions
extension DetailViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func createPickerView(){
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.codeField.inputView = pickerView
        
    }
    
    func dissmissClosePickerView() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(phoneDismiss))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        self.codeField.inputAccessoryView = toolbar
    }
    
    @objc func phoneDismiss(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.listOfCountryCodes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.listOfCountryCodes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedCountry = self.listOfCountryCodes[row]
        self.codeField.text = self.selectedCountry
    }
    
}



// DatePicker Functions
extension DetailViewController{
    
    func createDatePicker(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDismiss))
        toolbar.setItems([doneButton], animated: true)
        birthdayField.inputAccessoryView = toolbar
        
        datePicker.preferredDatePickerStyle = .wheels
        birthdayField.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    @objc func dateDismiss(){
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        birthdayField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}

// Validation Functions
extension DetailViewController{
    
    
    func nameValidation(){
        if nameField.text != ""{
            if let name = nameField.text{
                if name.count > 1 && name.count < 21 {
                    let nameFlag = name.rangeOfCharacter(from: lettersAndSpacesCharacterSet) == nil
                    if  nameFlag{
                        print("Valid name")
                        self.nameErrorLabel.isHidden = true
                        defaultBorderWidth()
                        surnameValidation()
                        
                    } else {
                        print("Invalid name")
                        self.nameErrorLabel.isHidden = false
                        nameView.layer.borderWidth = 1
                        nameView.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }else {
                    print("Invalid name")
                    self.nameErrorLabel.isHidden = false
                    nameView.layer.borderWidth = 1
                    nameView.layer.borderColor = UIColor.systemRed.cgColor
                }
            }
        }else {
            print("Invalid name")
            self.nameErrorLabel.isHidden = false
            nameView.layer.borderWidth = 1
            nameView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    
    func surnameValidation(){
        if surnameField.text != ""{
            if let surname = surnameField.text{
                if surname.count > 1 && surname.count < 21 {
                    let surnameFlag = surname.rangeOfCharacter(from: lettersAndSpacesCharacterSet) == nil
                    if  surnameFlag{
                        print("Valid surname")
                        self.surnameErrorLabel.isHidden = true
                        defaultBorderWidth()
                        birthdayValidation()
                        
                    } else {
                        print("Invalid surname")
                        self.surnameErrorLabel.isHidden = false
                        surnameView.layer.borderWidth = 1
                        surnameView.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }else {
                    print("Invalid surname")
                    self.surnameErrorLabel.isHidden = false
                    surnameView.layer.borderWidth = 1
                    surnameView.layer.borderColor = UIColor.systemRed.cgColor
                }
            }
        }else {
            print("Invalid surname")
            self.surnameErrorLabel.isHidden = false
            surnameView.layer.borderWidth = 1
            surnameView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    
    func birthdayValidation(){
        
        if birthdayField.text != ""{
            print("Valid birthday")
            birthdayErrorLabel.isHidden = true
            defaultBorderWidth()
            emailValidation()
        } else{
            print("Invalid birthday")
            birthdayErrorLabel.isHidden = false
            birthdayView.layer.borderWidth = 1
            birthdayView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    
    func emailValidation(){
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        if emailField.text != ""{
            if let email = emailField.text{
                
                let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                if emailPred.evaluate(with: email){
                    print("Valid email")
                    defaultBorderWidth()
                    mailErrorLabel.isHidden = true
                    phoneNumberValidation()
                } else{
                    print("Invalid email")
                    mailErrorLabel.isHidden = false
                    emailView.layer.borderWidth = 1
                    emailView.layer.borderColor = UIColor.systemRed.cgColor
                }
            }
        }else {
            print("Invalid email")
            mailErrorLabel.isHidden = false
            emailView.layer.borderWidth = 1
            emailView.layer.borderColor = UIColor.systemRed.cgColor
        }

        
    }
    
    func phoneNumberValidation(){
        if codeField.text != ""{
            print("Valid code")
            defaultBorderWidth()
            if phoneNumberField.text != ""{
                if let phoneNumber = phoneNumberField.text{
                    if codeField.text == "+90"{
                        if phoneNumber.count < 11 {
                            print("Valid number")
                            phoneErrorLabel.isHidden = true
                            defaultBorderWidth()
                            noteValidation()
                        } else {
                            print("Invalid number")
                            phoneErrorLabel.isHidden = false
                            phoneView.layer.borderWidth = 1
                            phoneView.layer.borderColor = UIColor.systemRed.cgColor
                        }
                    } else{
                        if phoneNumber.count < 21 {
                            print("Valid number")
                            phoneErrorLabel.isHidden = true
                            defaultBorderWidth()
                            noteValidation()
                        }else{
                            print("Invalid number")
                            phoneErrorLabel.isHidden = false
                            phoneView.layer.borderWidth = 1
                            phoneView.layer.borderColor = UIColor.systemRed.cgColor
                        }
                    }
                }
            }else{
                print("Invalid number")
                phoneErrorLabel.isHidden = false
                phoneView.layer.borderWidth = 1
                phoneView.layer.borderColor = UIColor.systemRed.cgColor
            }
        } else {
            print("Invalid code")
            phoneErrorLabel.isHidden = false
            phoneView.layer.borderWidth = 1
            phoneView.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    func noteValidation(){
        if let note = notesField.text{
            if note.count < 101 {
                print("Valid note")
                savingCoreData()
                noteErrorLabel.isHidden = true
                defaultBorderWidth()
            } else{
                print("Invalid note")
                noteErrorLabel.isHidden = false
                noteView.layer.borderWidth = 1
                noteView.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


