//
//  CreateEmployeeController.swift
//  TrainningCoreData
//
//  Created by AHMED on 6/5/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate{
  func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController{
  
  var company: Company?
  
  var delegate: CreateEmployeeControllerDelegate?
  
  let nameLbl: UILabel = {
    let label = UILabel()
    label.text = "Name"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let nameTxtField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter name"
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let birthdayLbl: UILabel = {
    let label = UILabel()
    label.text = "Birthday"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let birthdayTxtField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "MM/dd/yyyy"
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Create Employee"
    
    setupCancelButton()
    
    view.backgroundColor = .darkBlue
    
    setupUI()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
  }
  
  @objc private func handleSave(){
    guard let employeeName = nameTxtField.text else { return }
    guard let company = self.company else { return }
    
    guard let birthdayText = birthdayTxtField.text else { return }
    
    if birthdayText.isEmpty || employeeName.isEmpty{
      showError(title: "Empty Birthday or employee name", message: "You have not entred a birthday or employee name")
      return
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    guard let birthdayDate = dateFormatter.date(from: birthdayText)else{
      showError(title: "Bad Date", message: "Birthday date entered not valid")
      
      return
    }
    
    guard let employeeType = employeesegmentedControl.titleForSegment(at: employeesegmentedControl.selectedSegmentIndex) else { return }
    
    let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
    
    if let error = tuple.1{
      print(error)
    }else{
      dismiss(animated: true, completion: {
        self.delegate?.didAddEmployee(employee: tuple.0!)
      })
    }
    
  }
  
  private func showError(title: String, message: String){
    let AlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    AlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(AlertController, animated: true, completion: nil)
  }
  
  let employeesegmentedControl: UISegmentedControl = {
    
    let types = [
      EmployeeType.Executive.rawValue,
      EmployeeType.SeniorManagement.rawValue,
      EmployeeType.Staff.rawValue,
      EmployeeType.Intern.rawValue
    ]
    
    let sc = UISegmentedControl(items: types)
    sc.selectedSegmentIndex = 0
    sc.tintColor = UIColor.darkBlue
    sc.translatesAutoresizingMaskIntoConstraints = false
    return sc
  }()
  
  private func setupUI(){
    _ = setupLightBlueBackgroundView(height: 150)
    
    view.addSubview(nameLbl)
    nameLbl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    nameLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    nameLbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
    nameLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(nameTxtField)
    nameTxtField.leftAnchor.constraint(equalTo: nameLbl.rightAnchor).isActive = true
    nameTxtField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    nameTxtField.bottomAnchor.constraint(equalTo: nameLbl.bottomAnchor).isActive = true
    nameTxtField.topAnchor.constraint(equalTo: nameLbl.topAnchor).isActive = true
    
    view.addSubview(birthdayLbl)
    birthdayLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor).isActive = true
    birthdayLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    birthdayLbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
    birthdayLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(birthdayTxtField)
    birthdayTxtField.leftAnchor.constraint(equalTo: birthdayLbl.rightAnchor).isActive = true
    birthdayTxtField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    birthdayTxtField.bottomAnchor.constraint(equalTo: birthdayLbl.bottomAnchor).isActive = true
    birthdayTxtField.topAnchor.constraint(equalTo: birthdayLbl.topAnchor).isActive = true
    
    view.addSubview(employeesegmentedControl)
    employeesegmentedControl.topAnchor.constraint(equalTo: birthdayLbl.bottomAnchor, constant: 0).isActive = true
    employeesegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    employeesegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    employeesegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
  }
  
}
