//
//  CompaniesController+UITableView.swift
//  TrainningCoreData
//
//  Created by AHMED on 6/5/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit


extension CompaniesController{
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let company = self.companies[indexPath.row]
    let employeesController = EmployeeController()
    employeesController.company = company
    
    navigationController?.pushViewController(employeesController, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
      let company = self.companies[indexPath.row]
      print("delete", company.name ?? "")
      
      self.companies.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      
      let context = CoreDataManager.shared.persistantContainer.viewContext
      context.delete(company)
      
      do{
        try context.save()
      }catch let saveErr{
        print("Failed to delete company", saveErr)
      }
      
    }
    deleteAction.backgroundColor = UIColor.lightRed
    
    let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
    editAction.backgroundColor = UIColor.darkBlue
    
    return[deleteAction, editAction]
  }
  
  private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath){
    print("Editing company is separate function")
    
    let editCompanyController = CreateCompanyController()
    editCompanyController.delegate = self
    editCompanyController.company = companies[indexPath.row]
    let navController = CustomNavigationController(rootViewController: editCompanyController)
    present(navController, animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "No companies available..."
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return companies.count == 0 ? 150 : 0
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = .lightBlue
    return view
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
    
    let company = companies[indexPath.row]
    cell.company = company
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return companies.count
  }

}
