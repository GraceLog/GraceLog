//
//  Date+Extension.swift
//  GraceLog
//
//  Created by 이건준 on 7/15/25.
//

import Foundation

extension Date {
    /// 기준일로부터 경과 일 수가 특정 값을 초과했는지 확인
    func hasElapsed(since referenceDate: Date = Date(), days: Int) -> Bool {
        let calendar = Calendar.current
        guard let fromDate = calendar.ordinality(of: .day, in: .era, for: referenceDate),
              let toDate = calendar.ordinality(of: .day, in: .era, for: self) else {
            return false
        }
        
        if days == 0 {
            return fromDate == toDate
        } else {
            return (fromDate - toDate) >= days
        }
    }
    
    /// 기준일 대비 '작년'인지 여부 (연도 기준 비교)
    func isLastYear(from referenceDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let referenceYear = calendar.component(.year, from: referenceDate)
        let selfYear = calendar.component(.year, from: self)
        return selfYear == referenceYear - 1
    }
    
    /// "yy년 M월" 형식으로 포맷팅
    func toYearMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 M월"
        return dateFormatter.string(from: self)
    }
    
    /// "년도, 월을 통해 해당 년도 월의 첫번째, 마지막 날짜를 내림"
    func getMonthDateRange(year: Int, month: Int) -> (startDate: String, endDate: String) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let startOfMonth = calendar.date(from: components) else {
            return ("", "")
        }
        
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let dayCount = range.count
        
        var endComponents = components
        endComponents.day = dayCount
        let endOfMonth = calendar.date(from: endComponents)!
        
        return (
            startDate: dateFormatter.string(from: startOfMonth),
            endDate: dateFormatter.string(from: endOfMonth)
        )
    }
}
