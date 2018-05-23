//
//  UIViewControllerExtencions.swift
//  TMDb-Client
//
//  Created by Maxim on 21.05.18.
//  Copyright © 2017 Maxim. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable{
    
    func showMessage(message: String?, responce: String?){
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: responce, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startAnimating() {
        
        let size = CGSize(width: 30, height: 30)
        
        self.startAnimating(size, message: "", type: .lineScale)
    }
}
