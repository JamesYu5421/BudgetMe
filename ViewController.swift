//
//  ViewController.swift
//  BudgetMeV2
//
//  Created by James Yu on 5/11/20.
//  Copyright © 2020 James Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var budgetDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        UserDefaults().set(false, forKey: "setupBudget")
        UserDefaults().bool(forKey: "setupBudget")
        
        // get the current day
        let date = Date()
        let calendar = Calendar.current
        
        let isFirstDay = (calendar.component(.day, from: date) == 1)
        
        // if firstday set totalCost to 0
        if isFirstDay {
            UserDefaults().set(0, forKey: "totalCost")
        }
//        UserDefaults().set(false, forKey: "setupBudget")
        
        if !UserDefaults().bool(forKey: "setupBudget"){
            UserDefaults().set(true, forKey: "setupBudget")
            UserDefaults().set(1000, forKey: "budgetValMonth")
            UserDefaults().set(0, forKey: "totalCost")
        }
        
        calculateBudgetMonth()
    }
    
    func calculateBudgetMonth(){
        //display the calculated Budget per month
        
        guard let tempBudget = UserDefaults().value(forKey: "budgetValMonth") as? Int else {
            return
        }
            
        guard let tempCost = UserDefaults().value(forKey: "totalCost") as? Int else {
            return
        }
            
        let tempRemainder = tempBudget - tempCost
        
        budgetDisplay.text = "$\(tempRemainder)"
        
    }
    
    @IBAction func displayMonthBudget(){
        calculateBudgetMonth()
        
    }
    
    // week budget is a work in progress
    
//    @IBAction func displayWeekBudget(){
//        //display the calculated Budget per week
//
//        // calculate number of days in this month
//        let date = Date()
//        let calendar = Calendar.current
//        let currentDay = calendar.component(.day, from: date)
//        let currentMonth = calendar.component(.month, from: date)
//        let currentYear = calendar.component(.year, from: date)
//
//        let targetDate = DateComponents(year: currentYear, month: currentMonth)
//        let date1 = calendar.date(from: targetDate)!
//        let range = calendar.range(of: .day, in: .month, for: date1)!
//        let numDays = range.count
//
//        // calculate number of weeks left
//        let numWeeks = ceil(Double(numDays)/7.00)
//        let numWeeksPassed = floor(Double(currentDay)/7.00)
//        let weeksLeft = Int(numWeeks - numWeeksPassed)
//
//
//
//
//        guard let tempBudget = UserDefaults().value(forKey: "budgetValMonth") as? Int else {
//            return
//        }
//
//        guard let tempCost = UserDefaults().value(forKey: "totalCost") as? Int else {
//            return
//        }
//
//        let tempRemainder = (tempBudget - tempCost) / weeksLeft
//
//        budgetDisplay.text = "$\(tempRemainder)"
//
//    }
    
    @IBAction func displayDayBudget(){
        //display the calculated Budget per day
        
        let date = Date()
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: date)
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)

        let targetDate = DateComponents(year: currentYear, month: currentMonth)
        let date1 = calendar.date(from: targetDate)!
        let range = calendar.range(of: .day, in: .month, for: date1)!
        let numDays = range.count - currentDay + 1
        
        guard let tempBudget = UserDefaults().value(forKey: "budgetValMonth") as? Int else {
            return
        }
            
        guard let tempCost = UserDefaults().value(forKey: "totalCost") as? Int else {
            return
        }
            
        let tempRemainder = (tempBudget - tempCost) / numDays
        
        budgetDisplay.text = "$\(tempRemainder)"
        
    }
    
    @IBAction func didTapPaymentList() {
        let vc = storyboard?.instantiateViewController(identifier: "paymentList") as! PaymentListViewController
        vc.title = "Payment List"
        vc.calcBud = {
            DispatchQueue.main.async {
                self.calculateBudgetMonth()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapModifyBudget() {
        let vc = storyboard?.instantiateViewController(identifier: "modify") as! ModifyViewController
        vc.title = "Modify Budget"
        vc.calcBud = {
            DispatchQueue.main.async {
                self.calculateBudgetMonth()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }


}

