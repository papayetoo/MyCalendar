//
//  ViewController.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/08/19.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit
import EventKit
import RxSwift
import RxCocoa

class CalendarViewController: UIViewController {
    
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView : UICollectionView!
    
    private var disposeBag = DisposeBag()
    private var currentYear : Int = 0
    private var currentMonth: [Date] = []
    private var currentDate : Date = Date()
    private var startDate: Date?
    private var endDate: Date?
    private var startWeekDay: Int?
    private var dateBehaviorSubject = BehaviorSubject<Date>(value: Date())
    private var currentDateBehaviorRelay = BehaviorRelay<Date>(value: Date())
    
    private var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM-dd"
        return formatter
    }()
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        var titles: [String] = []
//        var startDates : [Date] = []
//        var endDates : [Date] = []
        
        // event, reminder에 접근할 수 있는 클래스
        let eventStore = EKEventStore()
        // eventStore의 접근권한을 얻는 코드 requestAccess
        // info.plist에 Privacy 선언 필요.
        let lastMonth = Calendar(identifier: .gregorian).date(byAdding: DateComponents(month:-1), to: self.currentDate)!
        print(lastMonth)
        eventStore.requestAccess(to: .event) {
            (granted, error) in
            if granted{
                // 아이폰 기본 캘릭더에 있는 event 정보를 얻어올 수 있음.
                let calendars = eventStore.calendars(for: .event)
                // 현재 달의 초일부터 말일까지의 행사를 받아옴.
                let predicate = eventStore.predicateForEvents(withStart: lastMonth.startOfMonth, end: lastMonth.endOfMonth, calendars: calendars)
                // predicate에 맞는 event를 가져옴.
                let events = eventStore.events(matching: predicate)
                for event in events{
                    // 대한민국 공휴일만을 가져옴.
                    if event.calendar.title == "대한민국 공휴일"{
                    
                        guard let eventStart = event.startDate, let eventEnd = event.endDate else {
                            continue
                        }
                        
                        let oneDay = DateComponents(day:1)
                        var currentHoliday = eventStart
                        print(event.title)
                        print(Calendar.current.component(.day, from: currentHoliday), Calendar.current.component(.day, from: eventEnd))
//                        while Calendar.current.component(.day, from: currentHoliday) != Calendar.current.component(.day, from: eventEnd) || Calendar.current.component(.month, from: currentHoliday) != Calendar.current.component(.month, from: eventEnd) {
//                            print(currentHoliday)
//                            currentHoliday = Calendar.current.date(byAdding: oneDay, to: eventStart)!
//                        }
                    }
                }
                
            }else{
                // 접근권한을 얻지 못했을 때의 콘솔에 message 출력
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        }
    
        
//        self.setLabelLegnth()
//        self.calendarView.dataSource = self
//        self.calendarView.delegate = self
//
//
//        let dateObservable : Observable<Date> = self.dateBehaviorSubject.asObservable()
//        dateObservable
//            .map {Calendar.current.dateComponents([.year, .month], from :$0)}
//            .filter { $0.year != nil && $0.month != nil }
//            .subscribe(onNext: { d in
//                self.yearLabel.text = "\(d.year!)년"
//                self.monthLabel.text = "\(d.month!)월"
//            })
//            .disposed(by: disposeBag)
//
//        dateObservable
//            .map {Calendar.current.component(.weekday, from: $0.startOfMonth)}
//            .subscribe(onNext: {
//                var dateComponent = DateComponents()
//                if $0 > 0{
//                    dateComponent.day = -$0 + 1
//                }
//                self.startDate = Calendar.current.date(byAdding: dateComponent, to: self.currentDate.startOfMonth)!
//            })
//            .disposed(by: disposeBag)
//
//        dateObservable
//            .map {Calendar(identifier: .gregorian).component(.weekday, from: $0.toLocalTime().endOfMonth)}
//            .subscribe(onNext: {
//                var dateComponent = DateComponents()
//                if $0 < 7 {
//                    dateComponent.day = 7 - $0
//                }
//                self.endDate = Calendar(identifier: .gregorian).date(byAdding: dateComponent, to: self.currentDate.endOfMonth)!
//            })
//            .disposed(by: disposeBag)
      // SWIPE action을 한 UISwipeGetstureRecognzier에 몰아넣지 못하나?
    
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
        if sender.direction == .left {
            print("swipe left")
            components.month = -1
        }else if sender.direction == .right {
            print("swipe right")
            components.month = 1
        }
        
        self.currentDate = Calendar(identifier: .gregorian).date(byAdding: components, to: self.currentDate.startOfMonth)!
        self.dateBehaviorSubject.onNext(self.currentDate)
        self.calendarView.reloadData()
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
        components.day = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: self.startOfMonth)!
    }
    
    var endDayOfYear: Date {
        var components = DateComponents()
        components.month = 12 - self.month
        return Calendar(identifier: .gregorian).date(byAdding: components, to: self)!.endOfMonth
    }
    
    var month: Int {
        return Calendar(identifier: .gregorian).component(.month, from: self)
    }
    
    var day: Int{
        return Calendar(identifier: .gregorian).component(.day, from: self)
    }
    
    var weekDay: Int {
        return Calendar(identifier: .gregorian).component(.weekday, from: self)
    }
    
    func toLocalTime() -> Date {
        // Local 로 변경하지 않으면 시간대가 다르게 나옴.
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let calendarEndDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(day:1), to: self.endDate!)
        return Calendar(identifier: .gregorian).dateComponents([.day], from: self.startDate!, to: calendarEndDate!).day!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        _ = Observable<UICollectionView>
//            .just(self.calendarView)
//            .map { $0.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell}
            
        
        guard let dateCell = self.calendarView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCell else{
            return UICollectionViewCell()
        }
        
        guard let curDate = Calendar.current.date(byAdding: DateComponents(day:indexPath.item), to: self.startDate ?? Date()) else {
            return UICollectionViewCell()
        }
        
        
        if curDate.month != self.currentDate.month{
            self.dateFormatter.dateFormat = "MM/dd"
            dateCell.contentView.backgroundColor = .lightGray
        }else{
            self.dateFormatter.dateFormat = "dd"
            dateCell.contentView.backgroundColor = .white
        }
        dateCell.dateLabel.text = "\(dateFormatter.string(from:curDate))"
        dateCell.dateLabel.font = dateCell.dateLabel.font.withSize(13)
        if curDate.weekDay == 1 {
            dateCell.dateLabel.textColor = .red
        }else{
            dateCell.dateLabel.textColor = .black
        }
        return dateCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.3, left: 0.3, bottom: 0, right: 0.3)
    }
}

extension CalendarViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width - 20
        return CGSize(width: width / 7, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
    }
}