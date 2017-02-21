//
//  KMDateModel.swift
//  swift预览
//
//  Created by 张鹏 on 2017/2/18.
//  Copyright © 2017年 zp. All rights reserved.
//

import Foundation

class KMDateModel {

    static let current: KMDateModel = KMDateModel(date: Date())
    
    var date: Date?
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var weekDay: String = ""
    var timeString: String = ""

    init(date: Date) {
        
        let weekDays = ["日","一","二","三","四","五","六"]
        let calendar = Calendar.current
        let coms = calendar.dateComponents([.year,.month,.day,.weekday], from: date)
        self.date = date
        year = coms.year!
        month = coms.month!
        day = coms.day!
        weekDay = weekDays[coms.weekday! - 1]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        timeString = formatter.string(from: date)
    }
    
    convenience init(timeString: String) {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: timeString)
        self.init(date: date!)
    }
}










