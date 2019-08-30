//
//  UIViewController+Helpers.swift
//  TrainningCoreData
//
//  Created by AHMED on 6/5/1398 AP.
//  Copyright © 1398 AHMED. All rights reserved.
//

import UIKit

extension UIViewController{
  
  func setupPlusButtonNavBar(selector: Selector){
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plusIcon"), style: .plain, target: self, action: selector)
  }
  
  func setupCancelButton(){
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
  }
  
  @objc func handleCancelModal(){
    dismiss(animated: true, completion: nil)
  }
  
  func setupLightBlueBackgroundView(height: CGFloat) -> UIView{
    let lightBlueBackgroundView = UIView()
    lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
    lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(lightBlueBackgroundView)
    lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    return lightBlueBackgroundView
  }
}
