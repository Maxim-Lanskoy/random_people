//
//  User.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    var firstName: String = ""
    var lastName: String = ""
    var title: String = ""
    
    var gender: String = ""
    var phone: String = ""
    var dateOfRegistration: String = ""
    var dateOfBirth: String = ""
    
    var city: String?
    var street: String?
    var state: String?
    var postCode: Int?
    
    var userAvatar: URL?

    var nationality: Nationality?
    
    private var nationalityString: String = "" {
        didSet {
            self.nationality = Nationality.init(rawValue: nationalityString.lowercased())
        }
    }
    
    required init?(map: Map) {
    }
    
    required init(coreDataUserObject: CDUser) {
        self.firstName = coreDataUserObject.firstName ?? ""
        self.lastName = coreDataUserObject.lastName ?? ""
        self.title = coreDataUserObject.title ?? ""
        
        self.gender = coreDataUserObject.gender ?? ""
        self.phone = coreDataUserObject.phone ?? ""
        self.dateOfRegistration = coreDataUserObject.dateOfRegistration ?? ""
        self.dateOfBirth = coreDataUserObject.dateOfBirth ?? ""
        
        self.city = coreDataUserObject.city
        self.street = coreDataUserObject.street
        self.state = coreDataUserObject.state
        self.postCode = Int(coreDataUserObject.postcode)
        
        self.userAvatar = URL(string: coreDataUserObject.userAvatar ?? "")
        self.nationality = coreDataUserObject.nationality != nil ? Nationality(rawValue: coreDataUserObject.nationality!) : nil
    }
    
    func getLocationString() -> String {
        let compactArray = ["\(nationality!.rawValue.capitalized)", self.city?.capitalized, self.street,
                            self.state, (self.postCode != nil ? "\(self.postCode!)" : nil)].flatMap { $0 }
        return compactArray.joined(separator: ", ")
    }
    
    func mapping(map: Map) {
        nationalityString  <-  map["nat"]
        phone              <-  map["phone"]
        gender             <-  map["gender"]
        dateOfBirth        <-  map["dob.date"]
        lastName           <-  map["name.last"]
        title              <-  map["name.title"]
        firstName          <-  map["name.first"]
        city               <-  map["location.city"]
        state              <-  map["location.state"]
        state              <-  map["location.state"]
        dateOfRegistration <-  map["registered.date"]
        street             <-  map["location.street"]
        postCode           <-  map["location.postcode"]
        userAvatar         <- (map["picture.large"], URLTransform())
    }
}

enum Nationality : String {
    case Au = "au"; case Br = "br"; case Ch = "ch"; case Ca = "ca"
    case De = "de"; case Dk = "dk"; case Es = "es"; case Fi = "fi"
    case Fr = "fr"; case Gb = "gb"; case Ie = "ie"; case Ir = "ir"
    case Nl = "nl"; case Nz = "nz"; case Tr = "tr"; case Us = "us"
    static let allCasesString: [String] = [Nationality.Au.rawValue, Nationality.Br.rawValue,
                                           Nationality.Ch.rawValue, Nationality.Ca.rawValue,
                                           Nationality.De.rawValue, Nationality.Dk.rawValue,
                                           Nationality.Es.rawValue, Nationality.Fi.rawValue,
                                           Nationality.Fr.rawValue, Nationality.Gb.rawValue,
                                           Nationality.Ie.rawValue, Nationality.Ir.rawValue,
                                           Nationality.Nl.rawValue, Nationality.Nz.rawValue,
                                           Nationality.Tr.rawValue, Nationality.Us.rawValue]
}
