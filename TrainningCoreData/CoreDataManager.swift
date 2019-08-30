//
//  CoreDataManager.swift
//  TrainningCoreData
//
//  Created by AHMED on 6/2/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import CoreData

struct CoreDataManager {
  
  static let shared = CoreDataManager()
  
  let persistantContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "IntermediateTrainningModel")
    container.loadPersistentStores { (storeDescription, err) in
      if let err = err{
        fatalError("Loading of store failed \(err)")
      }
    }
    return container
  }()
  
  func fetchCompanies() -> [Company]{
    let context = persistantContainer.viewContext
    
    let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
    
    do{
      let companies = try context.fetch(fetchRequest)
      return companies
    }catch let fetchErr{
      print("Failed to fetch companies", fetchErr)
      return []
    }
  }
  
  func createEmployee(employeeName: String, employeeType: String, birthday: Date,  company: Company) -> (Employee?, Error?){
    let context = persistantContainer.viewContext
    
    let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
    
     employee.company = company
    employee.type = employeeType
    
  //  let company = company(context: context)
    
    employee.setValue(employeeName, forKey: "name")
    
    let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
    
    employeeInformation.taxId = "456"
    employeeInformation.birthday = birthday
    //employeeInformation.setValue("456", forKey: "taxId")
    employee.employeeInformation = employeeInformation
    
    do{
      try context.save()
      return (employee, nil)
    }catch let err{
      print("Failed to create employee", err)
      return (nil, err)
    }
  }
  
  
  
}
