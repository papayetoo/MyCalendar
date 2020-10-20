//
//  DateCell.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/10/14.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit
import RxSwift

class DateCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = CGFloat(10)
        self.contentView.layer.borderWidth = CGFloat(1.2)
        self.contentView.layer.borderColor = UIColor.blue.cgColor
        print("Make Date Cell")
    }
    
    
}
