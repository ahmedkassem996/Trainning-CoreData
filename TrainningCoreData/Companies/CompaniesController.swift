//
//  ViewController.swift
//  TrainningCoreData
//
//  Created by AHMED on 5/28/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
  
  var companies = [Company]()
  
  @objc private func doWork(){
    print("Trying to do work...")
    
    CoreDataManager.shared.persistantContainer.performBackgroundTask { (backgroundContext) in
      (0...5).forEach { (value) in
        print(value)
        let company = Company(context: backgroundContext)
        company.name = String(value)
      }
      
      do{
        try backgroundContext.save()
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
      }catch let err{
        print("Failed to save:", err)
      }
    }
    
    // GCD - Grand Central Dispatch
    
    DispatchQueue.global(qos: .background).async {
      
    }
    
  }
  
    
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.companies = CoreDataManager.shared.fetchCompanies()
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
      UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doWork))
    ]
    
    view.backgroundColor = .white
    navigationItem.title = "Companies"
    tableView.backgroundColor = .darkBlue
    tableView.separatorColor = .white
    tableView.tableFooterView = UIView()
    tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
    
    setupPlusButtonNavBar(selector: #selector(handleAddCompany))
  }
  
  @objc func handleReset(){
    print("Attempting to delete all data core objects")
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
    
    do{
      try context.execute(batchDeleteRequest)
      
      var indexPathsToRemove = [IndexPath]()
      
      for (index, _) in companies.enumerated(){
        let indexPath = IndexPath(row: index, section: 0)
        indexPathsToRemove.append(indexPath)
      }
      companies.removeAll()
      tableView.deleteRows(at: indexPathsToRemove, with: .left)
    }catch let delErr{
      print("Failed to delete object from core data", delErr)
    }
    
  }
  
  @objc func handleAddCompany(){
    print("Adding Company...")
    
    let createCompanyController = CreateCompanyController()
    let navController = CustomNavigationController(rootViewController: createCompanyController)
    
    createCompanyController.delegate = self
    
    present(navController, animated: true, completion: nil)
  }

}

