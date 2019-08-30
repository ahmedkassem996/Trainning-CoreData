//
//  CompanyCell.swift
//  TrainningCoreData
//
//  Created by AHMED on 6/4/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell{
  
  var company: Company?{
    didSet{
      print(company?.name)
      
      nameFoundedDateLbl.text = company?.name
      
          if let imageData = company?.imageData{
            companyImageView.image = UIImage(data: imageData)
          }
      
      if let name = company?.name, let founded = company?.founded{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM:dd:yyy hh:mm:ss"
        let foundedDateString = dateFormatter.string(from: founded)
        let dateString = "\(name) - Founded: \(foundedDateString)"
        nameFoundedDateLbl.text = dateString
      }else{
        nameFoundedDateLbl.text = company?.name
      }
    }
  }
  
  let companyImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "plusPhoto"))
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 20
    imageView.clipsToBounds = true
    imageView.layer.backgroundColor = UIColor.darkBlue.cgColor
    imageView.layer.borderWidth = 1
    return imageView
  }()
  
  let nameFoundedDateLbl: UILabel = {
    let label = UILabel()
    label.text = "COMPANY NAME"
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = UIColor.tealColor
    
    addSubview(companyImageView)
    companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    addSubview(nameFoundedDateLbl)
    nameFoundedDateLbl.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
    nameFoundedDateLbl.topAnchor.constraint(equalTo: topAnchor).isActive = true
    nameFoundedDateLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    nameFoundedDateLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
