//
//  CreateCompanyController.swift
//  TrainningCoreData
//
//  Created by AHMED on 5/30/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
  func didAddCompany(company: Company)
  func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var company: Company?{
    didSet{
      nameTxtField.text = company?.name
      
      if let imageData = company?.imageData{
        companyImageView.image = UIImage(data: imageData)
        setupCircularImageStyle()
        
      }
      
      guard let founded = company?.founded else { return }
      datePicker.date = founded
    }
  }
  
  private func setupCircularImageStyle(){
    companyImageView.layer.cornerRadius = companyImageView.frame.width / 3
    companyImageView.clipsToBounds = true
    companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
    companyImageView.layer.borderWidth = 2
  }
  
  var delegate: CreateCompanyControllerDelegate?
  
//  var companiesController: CompaniesController?
  
  lazy var companyImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "plusPhoto"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
    return imageView
  }()
  
  @objc private func handleSelectPhoto(){
    print("Trying to select photo")
    
    let imagePickerController = UIImagePickerController()
    
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
      companyImageView.image = editedImage
      
    }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
      
      companyImageView.image = originalImage
    }
    
    setupCircularImageStyle()
    companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
    
    dismiss(animated: true, completion: nil)
  }
  
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
  
  let datePicker: UIDatePicker = {
    let dp = UIDatePicker()
    dp.datePickerMode = .date
    dp.translatesAutoresizingMaskIntoConstraints = false
    return dp
  }()
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = company == nil ? "Create Company" : "Edit Company"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    
    setupCancelButton()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    
    view.backgroundColor = UIColor.darkBlue
  
  }
  
  @objc private func handleSave(){
    if company == nil{
      createCompany()
    }else{
      saveCompanyChanges()
    }
  }
  
  private func saveCompanyChanges(){
    let context = CoreDataManager.shared.persistantContainer.viewContext
    
    company?.name = nameTxtField.text
    company?.founded = datePicker.date
    
    if let companyImage = companyImageView.image{
      //  let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
      let imageData = companyImage.jpegData(compressionQuality: 0.3)
      company?.imageData = imageData
    }
    
    do{
      try context.save()
      
      dismiss(animated: true, completion: {
        self.delegate?.didEditCompany(company: self.company!)
      })
    }catch let saveErr{
      print("Failed to save company changes", saveErr)
    }
  }
  
  private func createCompany(){
    print("Trying to save company...")
    
    let context = CoreDataManager.shared.persistantContainer.viewContext
    
    let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
    
    company.setValue(nameTxtField.text, forKey: "name")
    company.setValue(datePicker.date, forKey: "founded")
    
    if let companyImage = companyImageView.image{
    //  let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
      let imageData = companyImage.jpegData(compressionQuality: 0.3)
      company.setValue(imageData, forKey: "imageData")
    }
    
    do{
      try context.save()
      
      dismiss(animated: true, completion: {
        self.delegate?.didAddCompany(company: company as! Company)
      })
    }catch let saveErr{
      print("Failed to save company", saveErr)
    }
  }
  
  private func setupUI(){
    
    let lightBlueBackgroundView = setupLightBlueBackgroundView(height: 350)
    
    view.addSubview(companyImageView)
    companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
    companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    
    view.addSubview(nameLbl)
    nameLbl.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
    nameLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    nameLbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
    nameLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(nameTxtField)
    nameTxtField.leftAnchor.constraint(equalTo: nameLbl.rightAnchor).isActive = true
    nameTxtField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    nameTxtField.bottomAnchor.constraint(equalTo: nameLbl.bottomAnchor).isActive = true
    nameTxtField.topAnchor.constraint(equalTo: nameLbl.topAnchor).isActive = true
    
    view.addSubview(datePicker)
    datePicker.topAnchor.constraint(equalTo: nameLbl.bottomAnchor).isActive = true
    datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
  }

}
