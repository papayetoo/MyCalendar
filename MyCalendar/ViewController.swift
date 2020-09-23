//
//  ViewController.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/08/19.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    private var disposeBag = DisposeBag()
    private var currentYear : Int = 0
    private var currentMonth: Int = 0
    private var currentDate : Date = Date()
    private var dateBehaviorSubject = BehaviorSubject<Date>(value: Date())
    private var utcFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
        return formatter
    }
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setLabelLegnth()
        let currentDateComponents = Calendar.current.dateComponents([.year, .month], from: self.currentDate)
        print("GMT Date", self.utcFormatter.string(from: self.currentDate))
        print("currentDate", formatter.string(from: self.currentDate))
        print("startOfDay", formatter.string(from: self.currentDate.startOfDay))
        print("startOfMonth", self.currentDate.startOfMonth)
        print("endOfMonth", self.currentDate.endOfDay)
//        let gregorianCalendar = Calendar(identifier: .gregorian)
//        print(gregorianCalendar.dateComponents([.year, .month, .day], from: stOfMonth))
//        self.currentYear = currentDateComponents.year!
//        self.currentMonth = currentDateComponents.month!
        
        self.dateBehaviorSubject.asObservable()
            .map {Calendar.current.dateComponents([.year, .month], from :$0)}
            .filter { $0.year != nil && $0.month != nil }
            .subscribe(onNext: { d in
                self.yearLabel.text = "\(d.year!)"
                self.monthLabel.text = "\(d.month!)"
            })
            .disposed(by: disposeBag)
        
//        let curDateOb = Observable.just(self.currentDate).asObservable()
//        let curDateCompOb = curDateOb
//            .map {Calendar.current.dateComponents([.year, .month], from :$0)}
//            .filter { $0.year != nil && $0.month != nil }
//
//        let yearOb = Observable.just(self.currentYear).asObservable()
//        yearOb.subscribe(onNext: {
//            self.yearLabel.text = "\($0)"
//        })
//
//        curDateCompOb.subscribe(onNext: {
//            self.yearLabel.text = "\($0.year!)"
//            self.monthLabel.text = "\($0.month!)"
//            })
//            .disposed(by: disposeBag)
        
        
//            .subscribe(onNext:{
//                self.yearLabel.text = "\(String(describing: $0.year!))"
//                self.monthLabel.text = "\(String(describing: $0.month!))"
//        })
//        self.yearLabel.text = "\(String(describing: formatter.string(from: self.currentDate)))"
//        formatter.dateFormat = "MM"
//        self.monthLabel.text = "\(String(describing: formatter.string(from: self.currentDate)))"
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        self.view.addGestureRecognizer(swipeRightRecognizer)
    }
    
    func setLabelLegnth(){
        if self.yearLabel.adjustsFontSizeToFitWidth == false {
            self.yearLabel.adjustsFontSizeToFitWidth = true
        }
        if self.monthLabel.adjustsFontSizeToFitWidth == false{
            self.monthLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer){
        var components = DateComponents()
//        _ = Observable.just(sender)
//            .map { switch $0.direction{
//            case .left:
//                components.month = -1
//            case .right:
//                components.month = 1
//            default:
//                components.month = 0
//            }
//        }
                    
//        var components = DateComponents()
        if sender.direction == .left {
            print("swipe left")
//            self.currentYear += 1
            components.month = -1
        }else if sender.direction == .right {
            print("swipe left")
//            self.currentYear -= 1
            components.month = 1
        }
        
//        print(self.currentYear)
        self.currentDate = Calendar(identifier: .gregorian).date(byAdding: components, to: self.currentDate.startOfMonth)!
        self.dateBehaviorSubject.onNext(self.currentDate)
//        _ = Observable.just(self.currentDate)
//            .map {Calendar.current.dateComponents([.year, .month], from :$0)}
//            .filter {$0.year != nil && $0.month != nil}
//            .subscribe(onNext:{
//                self.yearLabel.text = "\(String(describing: $0.year!))"
//                self.monthLabel.text = "\(String(describing: $0.month!))"
//        })
    }
    
    func rxSwipeAction(_ sender: UISwipeGestureRecognizer) -> Observable<Int>{
        return Observable<Int>.create { seal in
            return Disposables.create()
        }
    }
}

extension Date{
     var startOfDay: Date {
           let interval = Calendar.current.dateInterval(of: .month, for: self)
           return (interval?.start.toLocalTime())!
    }
    
     var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!.toLocalTime()
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: self.startOfMonth)!
    }
    
    func getStart(of component: Calendar.Component, calendar: Calendar = Calendar.current) -> Date?{
        return calendar.dateInterval(of: component, for: self)?.start
    }
    
    func toLocalTime() -> Date {
        // Local 로 변경하지 않으면 시간대가 다르게 나옴.
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
