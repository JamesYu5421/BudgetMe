//
//  ModifyViewController.swift
//  BudgetMeV2
//
//  Created by James Yu on 5/11/20.
//  Copyright © 2020 James Yu. All rights reserved.
//

import UIKit

class ModifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var modField:UITextField!
    
    var calcBud: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBudget))

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveBudget()
        
        return true
    }
    
    @objc func saveBudget() {
        
        guard let text = modField.text, !text.isEmpty else {
            return
        }
        
        let text_int = Int(text)

        UserDefaults().set(text_int, forKey: "budgetValMonth")
        
        
        calcBud?()
        
        navigationController?.popViewController(animated: true)
        
    }
    

}
