//
//  ListApiManager.swift
//  AppList
//
//  Created by dc on 2022/3/23.
//

import Foundation
import SwiftUI
import Combine

enum ApiError: Error {
    case resError
    case parseError
    case unknowError
    
    var message: String {
        switch self {
        case .resError:
            return "网络错误"
        case .parseError:
            return "数据解析错误"
        case .unknowError:
            return "未知错误"
        }
    }
}

final class ListApiManager {
    var path: String
    
    init(path: String) {
        self.path = path
    }
    
    func fetchListData() -> AnyPublisher<[ListCellModel], ApiError> {
        let url = URL(string: path)
        return URLSession.shared.dataTaskPublisher(for: url!)
            .retry(3)
            .map { data, _ in
                data
            }
            .mapError { _ in
                ApiError.resError
            }
            .decode(type: ListModel.self, decoder: JSONDecoder())
            .mapError {_ in
                ApiError.parseError
            }
            .map { data in
                data.results
            }
            .eraseToAnyPublisher()
    }
    
}
