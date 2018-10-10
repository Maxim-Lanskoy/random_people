//
//  FilteringOptionsViewController.swift
//  Random People
//
//  Created by Maxim Lanskoy on 09.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit

class FilteringOptionsViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var genderOptionSwitchControl: UISwitch!
    @IBOutlet weak var nationalityOptionSwitchControl: UISwitch!
    
    @IBOutlet weak var genderValueTexdtField: UITextField!
    @IBOutlet weak var nationalityValueTextField: UITextField!
    
    //MARK: - Variables
    
    let genderOptionsArray = ["male", "female"]
    let nationalityOptionsArray = Nationality.allCasesString
    
    //MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePickerViews()
        self.configureWithSavedData()
    }
    
    //MARK: - Interface Builder actions
    
    @IBAction func switchControlValueDidChanged(_ sender: UISwitch) {
        if sender == self.genderOptionSwitchControl {
            if genderOptionSwitchControl.isOn {
                let text = FilterOptionsHelper.shared.genderFilterOption ?? genderOptionsArray[0]
                configureTextField(textField: genderValueTexdtField, grayed: false, text: text.capitalized)
                FilterOptionsHelper.shared.genderFilterOption = text
                FilterOptionsHelper.shared.saveGenderFilter()
            } else {
                FilterOptionsHelper.shared.genderFilterOption = nil
                FilterOptionsHelper.shared.saveGenderFilter()
                configureTextField(textField: self.genderValueTexdtField, grayed: true, text: "")
            }
        } else if sender == self.nationalityOptionSwitchControl {
            if nationalityOptionSwitchControl.isOn {
                let text = FilterOptionsHelper.shared.nationalityFilterOption ?? nationalityOptionsArray[0]
                configureTextField(textField: nationalityValueTextField, grayed: false, text: text.capitalized)
                FilterOptionsHelper.shared.nationalityFilterOption = text
                FilterOptionsHelper.shared.saveNationalityFilter()
            } else {
                FilterOptionsHelper.shared.nationalityFilterOption = nil
                FilterOptionsHelper.shared.saveNationalityFilter()
                configureTextField(textField: nationalityValueTextField, grayed: true, text: "")
            }
        }
    }
    
    //MARK: - Private methods
    
    private func configureTextField(textField: UITextField, grayed: Bool, text: String) {
        textField.isEnabled = !grayed
        textField.isUserInteractionEnabled = !grayed
        textField.alpha = grayed ? 0.7 : 1.0
        textField.text = text
    }
    
    private func configureWithSavedData() {
        if let genderFilterOption = FilterOptionsHelper.shared.genderFilterOption?.capitalized, genderFilterOption.count > 0 {
            self.genderOptionSwitchControl.isOn = true
            self.configureTextField(textField: genderValueTexdtField, grayed: false, text: genderFilterOption)
        }
        if let nationalityFilterOption = FilterOptionsHelper.shared.nationalityFilterOption?.capitalized, nationalityFilterOption.count > 0 {
            self.nationalityOptionSwitchControl.isOn = true
            self.configureTextField(textField: nationalityValueTextField, grayed: false, text: nationalityFilterOption)
        }
    }
    
    private func configurePickerViews() {
        let pickerViewForGender = UIPickerView()
        pickerViewForGender.delegate = self
        pickerViewForGender.dataSource = self
        self.genderValueTexdtField.pickerView = pickerViewForGender
        self.genderValueTexdtField.addTarget(self, action: #selector(didCloseGenderPickerView), for: .editingChanged)
        let pickerViewForNationality = UIPickerView()
        pickerViewForNationality.delegate = self
        pickerViewForNationality.dataSource = self
        self.nationalityValueTextField.pickerView = pickerViewForNationality
        self.nationalityValueTextField.addTarget(self, action: #selector(didCloseNationalityPickerView), for: .editingChanged)
    }
    
    @objc internal func didCloseGenderPickerView() {
        self.genderValueTexdtField.text = self.genderOptionsArray[(self.genderValueTexdtField.pickerView?.selectedRow(inComponent: 0))!].capitalized
        FilterOptionsHelper.shared.genderFilterOption = self.genderValueTexdtField.text?.lowercased()
        FilterOptionsHelper.shared.saveGenderFilter()
    }
    
    @objc internal func didCloseNationalityPickerView() {
        self.nationalityValueTextField.text = self.nationalityOptionsArray[(self.nationalityValueTextField.pickerView?.selectedRow(inComponent: 0))!].capitalized
        FilterOptionsHelper.shared.nationalityFilterOption = self.nationalityValueTextField.text?.lowercased()
        FilterOptionsHelper.shared.saveNationalityFilter()
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension FilteringOptionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderValueTexdtField.pickerView {
            return genderOptionsArray.count
        } else {
            return nationalityOptionsArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderValueTexdtField.pickerView {
            self.genderValueTexdtField.text = genderOptionsArray[row].capitalized
        } else {
            self.nationalityValueTextField.text = nationalityOptionsArray[row].capitalized
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderValueTexdtField.pickerView {
            return self.genderOptionsArray[row].capitalized
        } else {
            return self.nationalityOptionsArray[row].uppercased()
        }
    }
}

//MARK: - UITextFieldDelegate
extension FilteringOptionsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.genderValueTexdtField {
            let index = self.genderOptionsArray.index(where: { $0 == textField.text!.lowercased()})
            self.genderValueTexdtField.pickerView?.selectRow(index ?? 0, inComponent: 0, animated: false)
        }
        if textField == self.nationalityValueTextField {
            let index = self.nationalityOptionsArray.index(where: { $0 == textField.text!.lowercased()})
            self.nationalityValueTextField.pickerView?.selectRow(index ?? 0, inComponent: 0, animated: false)
        }
    }
}
