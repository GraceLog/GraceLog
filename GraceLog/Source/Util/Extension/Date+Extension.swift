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
    
    /// 현재 시점 기준 상대적 시간 문자열 반환
    /// - Returns: "오늘", "하루전", "2일전", "1주전", "1개월전", "작년", "2년전" 등
    func relativeTimeString(from referenceDate: Date = Date()) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .weekOfMonth, .day],
            from: self,
            to: referenceDate
        )
        
        guard let years = components.year,
              let months = components.month,
              let weeks = components.weekOfMonth,
              let days = components.day else {
            return ""
        }
        
        if years == 0 && months == 0 && weeks == 0 && days == 0 {
            return "오늘"
        }
        
        if years == 0 && months == 0 && weeks == 0 && days == 1 {
            return "어제"
        }
        
        if years == 0 && months == 0 && weeks == 0 && days > 1 && days < 7 {
            return "\(days)일 전"
        }
        
        if days >= 7 && days <= 13 && months == 0 && years == 0 {
            return "지난주"
        }
        
        if days >= 14 && days < 28 && months == 0 && years == 0 {
            let weeks = days / 7
            return "\(weeks)주일 전"
        }
        
        if years == 0 && months > 0 && months < 12 {
            return "\(months)개월 전"
        }
        
        if years == 1 {
            return "작년"
        }
        
        // 2년전 ~ N년전
        if years > 1 {
            return "\(years)년 전"
        }
        
        return ""
    }
}
