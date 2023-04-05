//
//  Date+Ext.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation

extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: 1, to: date)!

        var arrDates = [String]()

        for _ in 1 ... nDays {
            date = cal.date(byAdding: .day, value: -1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
    
    static func getDatesOfCurrentMonth() -> [String] {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd"
          let currentDayString = dateFormatter.string(from: Date())
          let currentDay = Int(currentDayString) ?? 0

          let cal = NSCalendar.current
          var date = cal.startOfDay(for: Date())
          date = cal.date(byAdding: .day, value: 1, to: date)!

          var arrDates = [String]()

          for _ in 1 ... currentDay {
              date = cal.date(byAdding: .day, value: -1, to: date)!

              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd/MM/yyyy"
              let dateString = dateFormatter.string(from: date)
              arrDates.append(dateString)
          }
          return arrDates
      }

}
