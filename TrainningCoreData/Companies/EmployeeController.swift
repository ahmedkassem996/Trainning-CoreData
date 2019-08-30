//
//  EmployeeController.swift
//  TrainningCoreData
//
//  Created by AHMED on 6/5/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit
import  CoreData

class IndentedLabel: UILabel{
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    let customRect = rect.inset(by: insets)
    super.drawText(in: customRect)
  }
}

class EmployeeController: UITableViewController, CreateEmployeeControllerDelegate {
  
  func didAddEmployee(employee: Employee){
  //  employees.append(employee)
//    fetchEmployee()
//    tableView.reloadData()
    
    guard let section = employeeTypes.index(of: employee.type!) else { return }
    let row = allEmployees[section].count
    
    let insertionIndexPath = IndexPath(row: row, section: section)
    
    allEmployees[section].append(employee)
    
    tableView.insertRows(at: [insertionIndexPath], with: .middle)
  }
  
  var company: Company?
  var employees = [Employee]()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = company?.name
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = IndentedLabel()
    label.backgroundColor = UIColor.lightBlue
//    if section == 0{
//      label.text = EmployeeType.SeniorManagement.rawValue
//    }else if section == 1{
//      label.text = EmployeeType.SeniorManagement.rawValue
//    }else{
//      label.text = EmployeeType.Staff.rawValue
//    }
    
    label.text = employeeTypes[section]
    
    label.textColor = UIColor.darkBlue
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  var allEmployees = [[Employee]]()
  
  let employeeTypes = [
    EmployeeType.Intern.rawValue,
    EmployeeType.Executive.rawValue,
    EmployeeType.SeniorManagement.rawValue,
    EmployeeType.Staff.rawValue
    
  ]
  
  private func fetchEmployee(){
    
    guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
    
    allEmployees = []
    
    employeeTypes.forEach { (employeeType) in
      allEmployees.append(
        companyEmployees.filter{$0.type == employeeType}
      )
    }
    
//    let executives = companyEmployees.filter { (employee) -> Bool in
//      return employee.type == EmployeeType.Executive.rawValue
//    }
//    
//    let seniorManagment = companyEmployees.filter{$0.type == EmployeeType.SeniorManagement.rawValue}
//    
//    allEmployees = [
//      executives,
//      seniorManagment,
//      companyEmployees.filter{$0.type == EmployeeType.Staff.rawValue}
//    ]
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return allEmployees.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return allEmployees[section].count
//    if section == 0{
//      return shortNameEmployees.count
//    }
//    return longNameEmployees.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
//    if indexPath.section == 0 {
//      employee = shoretName
//    }
//
//    let employee = employees[indexPath.row]
    
//    let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
    
    let employee = allEmployees[indexPath.section][indexPath.row]
    
    cell.textLabel?.text = employee.name
    
    if let birthday = employee.employeeInformation?.birthday{
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM/dd/yyyy"
      
      cell.textLabel?.text = "\(employee.name ?? "")    \(dateFormatter.string(from: birthday))"
    }

    
//    if let taxId = employee.employeeInformation?.taxId{
//      cell.textLabel?.text = "\(employee.name ?? "")    \(taxId)"
//    }
    
    cell.backgroundColor = UIColor.tealColor
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    
    return cell
  }
  
  let cellId = "CELLID"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchEmployee()
    
    tableView.backgroundColor = UIColor.darkBlue
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    
    setupPlusButtonNavBar(selector: #selector(handleAdd))
  }
  
  @objc private func handleAdd(){
    print("Trying to add an employee...")
    
    let createEmployeeController = CreateEmployeeController()
    createEmployeeController.delegate = self
    createEmployeeController.company = company
    let navController = UINavigationController(rootViewController: createEmployeeController)
    present(navController, animated: true, completion: nil)
  }
  
}


