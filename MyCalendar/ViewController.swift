//
//  ViewController.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/08/19.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    private var currentYear : Int = 0
    private var currentMonth: Int = 0
    private let currentDate : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print(Calendar.current.component(.weekday, from: Date()))
        self.setLabelLegnth()
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: self.currentDate)
        let createTest = Observable<Int>.create
        self.currentYear = currentDateComponents.year!
        self.currentMonth = currentDateComponents.month!
        self.yearLabel.text = "\(String(describing: self.currentYear))"
        self.monthLabel.text = "\(String(describing: self.currentMonth))"
        let swipeRecongnizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeRecongnizer.direction = .left
        self.view.addGestureRecognizer(swipeRecongnizer)
    }
    
    func setLabelLegnth(){
        if self.yearLabel.adjustsFontSizeToFitWidth == false {
            self.yearLabel.adjustsFontSizeToFitWidth = true
        }
        if self.monthLabel.adjustsFontSizeToFitWidth == false{
            self.monthLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            if self.currentMonth == 1{
                self.currentYear -= 1
                self.yearLabel.text = "\(String(describing: self.currentYear))"
            }
            self.currentMonth = self.currentMonth != 1 ? self.currentMonth - 1 : 12
            self.monthLabel.text = "\(String(describing: self.currentMonth))"
            let calendar = Calendar(identifier: .gregorian)
            let test = DateComponents(year: self.currentYear, month: self.currentMonth)
        }
    }
    
    func rxSwipeAction(_ sender: UISwipeGestureRecognizer) -> Observable<Int>{
        return Observable<Int>.create { seal in
            return Disposables.create()
        }
    }
}

