//
//  PaymentListViewController.swift
//  BudgetMeV2
//
//  Created by James Yu on 5/11/20.
//  Copyright © 2020 James Yu. All rights reserved.
//

import UIKit

class PaymentListViewController: UIViewController {

    @IBOutlet var tableView:UITableView!
    
    var payments = [String]()
    
    var calcBud: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Payment List"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // get the current day
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current

        let isFirstDay = (calendar.component(.day, from: date) == 1)

        // if firstday set count to 0
        if isFirstDay {
            UserDefaults().set(0, forKey: "count")
            payments = [String]()
        }
        //Setup

//        UserDefaults().set(false, forKey: "setup")
        
        if !UserDefaults().bool(forKey: "setup"){
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        updatePayments()
        

        // Do any additional setup after loading the view.
    }
    
    func updatePayments(){
        payments.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        for x in 0...count {
            if let payment = UserDefaults().value(forKey: "payment_\(x)") as? String {
                if let value = UserDefaults().value(forKey: "value_\(x)") as? String{
                    payments.append("\(payment)(\(value))")
                }
            }
            
        }
        
        tableView.reloadData()
        
        // updates displayed budget at home page
        calcBud?()
    }
    
    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "Add Payment"
        vc.update = {
            DispatchQueue.main.async {
                self.updatePayments()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PaymentListViewController:UITableViewDelegate {
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "payment") as! PaymentViewController
        vc.title = "Add Payment"
        vc.payment = payments[indexPath.row]
        
        // its indexPath.row + 1 because thats how i set the indexing of payments
        vc.paymentIndex = indexPath.row + 1
        vc.calcBud = {
            DispatchQueue.main.async {
                self.calcBud!()
            }
        }
        vc.update = {
            DispatchQueue.main.async {
                self.updatePayments()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PaymentListViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = payments[indexPath.row]
        
        return cell
    }
}
