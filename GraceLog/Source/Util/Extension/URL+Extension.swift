//
//  URL+Extension.swift
//  GraceLog
//
//  Created by 이건준 on 8/12/25.
//

import Foundation

extension URL {
    func fetchData() async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: self)
        return data
    }
}

