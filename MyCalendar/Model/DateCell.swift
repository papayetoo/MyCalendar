//
//  DateCell.swift
//  MyCalendar
//
//  Created by 최광현 on 2020/10/14.
//  Copyright © 2020 최광현. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("Make Date Cell")
    }
    
    
}
