//
//  Person.swift
//  rehber
//
//  Created by Sefa MacBook Pro on 4.05.2021.
//

import Foundation


class PersonX: Equatable{
    
    static func == (lhs: PersonX, rhs: PersonX) -> Bool {
        if lhs.idOfPerson == rhs.idOfPerson{
            return true
        } else{
            return false
        }
    }
    
    var nameOfPerson : String?
    var surnameOfPerson : String?
    var birthdateOfPerson : String?
    var emailOfPerson : String?
    var codeOfPerson : String?
    var phoneOfPerson : String?
    var noteOfPerson : String?
    var idOfPerson : UUID?
    
    init(name: String?, surname: String?, birthdate: String?, email: String?, code: String?, phone: String?, note: String?, id: UUID?) {
        
        self.nameOfPerson = name
        self.surnameOfPerson = surname
        self.birthdateOfPerson = birthdate
        self.emailOfPerson = email
        self.codeOfPerson = code
        self.phoneOfPerson = phone
        self.noteOfPerson = note
        self.idOfPerson = id
    }
}
