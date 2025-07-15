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
}
