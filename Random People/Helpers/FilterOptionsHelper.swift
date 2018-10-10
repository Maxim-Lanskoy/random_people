//
//  FilterOptionsHelper.swift
//  Random People
//
//  Created by Maxim Lanskoy on 10.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import Foundation

class FilterOptionsHelper {
    
    //MARK: - Singletone
    
    static let shared = FilterOptionsHelper()
    
    private var _genderFilterOption: String? = nil {
        didSet {
            isUpdateNeeded = true
        }
    }
    private var _nationalityFilterOption: String? = nil {
        didSet {
            isUpdateNeeded = true
        }
    }
    
    var genderFilterOption: String? {
        set {
            _genderFilterOption = newValue
        }
        get {
            return _genderFilterOption ?? FilterOptionsHelper.loadSavedGenderFilter()
        }
    }
    
    var nationalityFilterOption: String? {
        set {
            _nationalityFilterOption = newValue
        }
        get {
            return _nationalityFilterOption ?? FilterOptionsHelper.loadSavedNationalityFilter()
        }
    }

    var isUpdateNeeded: Bool = false
    
    //MARK: - Public
    
    func saveGenderFilter() {
        let savingFilter = _genderFilterOption
        UserDefaults.standard.set(savingFilter ?? nil, forKey: "FilterOptionHelperGenderOption")
    }
    
    func saveNationalityFilter() {
        let savingFiler = _nationalityFilterOption
        UserDefaults.standard.set(savingFiler ?? nil, forKey: "FilterOptionHelperNationalityOption")
    }
    
    //MARK: - Private
    
    private class func loadSavedGenderFilter() -> String? {
        guard let decodedValue  = UserDefaults.standard.object(forKey: "FilterOptionHelperGenderOption") as? String else {
            return nil
        }
        return decodedValue
    }
    
    private class func loadSavedNationalityFilter() -> String? {
        guard let decodedValue  = UserDefaults.standard.object(forKey: "FilterOptionHelperNationalityOption") as? String else {
            return nil
        }
        return decodedValue
    }
}
