//
//  DateFormatterFactory.swift
//  GraceLog
//
//  Created by 이건준 on 7/10/25.
//

import Foundation

enum DateFormatterFactory {
    private static var formatter: DateFormatter {
        DateFormatter().then {
            $0.locale = Locale(identifier: "ko_KR")
        }
    }
    
    /// yy년 M월 d일 (예: 24년 7월 16일)
    static var dateWithShortKorean: DateFormatter {
        formatter.then { $0.dateFormat = "yy년 M월 d일" }
    }
    
    /// M/d 형식 (예: 2/4, 12/1)
    static var monthDaySlash: DateFormatter {
        formatter.then { $0.dateFormat = "M/d" }
    }
    
    /// yyyy.MM.dd 형식 (예: 2025.09.07)
    static var dateWithDot: DateFormatter {
        formatter.then { $0.dateFormat = "yyyy.MM.dd" }
    }
    
    // yy년 M월 형식 (예: 25년 7월)
    static var yearMonth: DateFormatter {
        formatter.then { $0.dateFormat = "yy년 M월" }
    }
    
    /// "yy년 M월" 형식으로 포맷팅
    static func toYearMonthString(from date: Date) -> String {
        yearMonth.string(from: date)
    }
    
    /// 년도, 월을 통해 해당 년도 월의 첫번째, 마지막 날짜를 반환
    static func getMonthDateRange(year: Int, month: Int) -> (startDate: String, endDate: String) {
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
    
    /// 서버 응답의 날짜 문자열을 Date로 변환 (형식: "yyyy-MM-dd'T'HH:mm:ss")
    static func dateFromServerString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: dateString)
    }
}
