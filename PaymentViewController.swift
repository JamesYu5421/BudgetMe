//
//  PaymentViewController.swift
//  BudgetMeV2
//
//  Created by James Yu on 5/14/20.
//  Copyright © 2020 James Yu. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var payment:String?
    
    var paymentIndex:Int?
    
    var calcBud: (() -> Void)?
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = payment
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deletePayment))
        
//        print("paymentIndex: \(paymentIndex)")
    }
    
    @objc func deletePayment() {
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        let newCount = count - 1
        
        for x in 0...count {
//            print("forLoop Started")
            if x > paymentIndex!{
                let atEnd = (count == x)
                if !atEnd{
                    guard let nextPay = UserDefaults().value(forKey: "payment_\(x+1)") as? String else {
                        return
                    }
                    UserDefaults().setValue(nextPay, forKey: "payment_\(x)")
                    
                    guard let nextVal = UserDefaults().value(forKey: "value_\(x+1)") as? String else {
                        return
                    }
                    UserDefaults().setValue(nextVal, forKey: "value_\(x)")
                } else {
                    UserDefaults().setValue(nil, forKey: "payment\(count)")
                    UserDefaults().setValue(newCount, forKey: "count")
                }
            }
            let paymentStr = payment?.components(separatedBy: "(")[0]
            let match = (x == paymentIndex!)
            
            if match {
//                    print("match found")
                guard let previousCost = UserDefaults().value(forKey: "totalCost") as? Int else {
                    return
                }
                guard let tempVal = UserDefaults().value(forKey: "value_\(x)") as? String else {
                    return
                }
//                    print(previousCost)
//                    print(tempVal)
                let newCost: Int = previousCost - Int(tempVal)!
//                    print(newCost)
                
                UserDefaults().set(newCost, forKey: "totalCost")
//                    print("newCost: \(newCost)")
                
//                    print("found payment set true")
                let atEnd = (count == x)
                if !atEnd{
                    guard let nextPay = UserDefaults().value(forKey: "payment_\(x+1)") as? String else {
                        return
                    }
                    UserDefaults().setValue(nextPay, forKey: "payment_\(x)")
                    
                    guard let nextVal = UserDefaults().value(forKey: "value_\(x+1)") as? String else {
                        return
                    }
                    UserDefaults().setValue(nextVal, forKey: "value_\(x)")
                } else {
                    UserDefaults().setValue(nil, forKey: "payment\(count)")
                    UserDefaults().setValue(newCount, forKey: "count")
                }
            }
            
            
        }
//        print("exited loop")
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }

}
