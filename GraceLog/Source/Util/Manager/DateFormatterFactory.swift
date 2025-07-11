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
  
  static var dateWithShortKorean: DateFormatter {
    formatter.then { $0.dateFormat = "yy년 M월 d일" }
  }
}
