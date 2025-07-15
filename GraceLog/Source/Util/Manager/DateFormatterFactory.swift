//
//  DateFormatterFactory.swift
//  GraceLog
//
//  Created by 이건준 on 7/10/25.
//

import Foundation

enum DateformatterFactory {
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
}
