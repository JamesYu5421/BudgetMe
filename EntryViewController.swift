//
//  EntryViewController.swift
//  BudgetMeV2
//
//  Created by James Yu on 5/11/20.
//  Copyright © 2020 James Yu. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField:UITextField!
    
    @IBOutlet var valueField:UITextField!
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        
        valueField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePayment))

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        savePayment()
        
        return true
    }
    
    @objc func savePayment() {
        
        guard let text = nameField.text, !text.isEmpty else {
            return
        }
        
        guard let text1 = valueField.text, !text1.isEmpty else {
            return
        }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        
        let newCount:Int = count + 1
        
        // used for calculating total cost
        
        let valInt: Int = Int(text1)!
        
        guard let previousCost = UserDefaults().value(forKey: "totalCost") as? Int else {
            return
        }
        
        let newCost: Int = previousCost + valInt
        
        UserDefaults().set(newCost, forKey: "totalCost")
        
        // these default updates are for listing
        UserDefaults().set(newCount, forKey: "count")
        
        UserDefaults().set(text, forKey: "payment_\(newCount)")
        
        UserDefaults().set(text1, forKey: "value_\(newCount)")
        
        
        update?()
        
        navigationController?.popViewController(animated: true)
        
    }
}
