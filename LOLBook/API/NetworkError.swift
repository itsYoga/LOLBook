//
//  NetworkError.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import Foundation

// 定義網路錯誤類型的枚舉，符合 Error 協議
enum NetworkError: Error, CustomStringConvertible {
    // 網路錯誤的各種情況
    case response(statusCode: Int) // HTTP 回應錯誤，包含狀態碼
    case badUrl // 無效的 URL 錯誤
    case urlSession(URLError?) // URLSession 請求錯誤
    case parsing(DecodingError?) // 解析錯誤，通常是 JSON 解析錯誤
    case undefined // 未定義的錯誤，表示未知錯誤

    // 用戶友好的錯誤描述
    var userDescription: String {
        switch self {
        case .parsing, .badUrl, .undefined:
            return "Something went wrong" // 通用錯誤訊息
        case .response:
            return "Connection failed" // 連線失敗的錯誤訊息
        case let .urlSession(error):
            return error?.localizedDescription ?? "Something went wrong" // URLSession 錯誤訊息
        }
    }

    // 用於調試的錯誤描述
    var description: String {
        switch self {
        case let .parsing(error):
            return "parsing error: \(String(describing: error))" // 解析錯誤
        case .badUrl:
            return "wrong URL" // 無效 URL 錯誤
        case let .urlSession(error):
            return error?.localizedDescription ?? "Error URL session" // URLSession 錯誤
        case .undefined:
            return "unknown error" // 未知錯誤
        case let .response(statusCode: statusCode):
            return "response error with code: \(statusCode)" // 回應錯誤及其狀態碼
        }
    }
}
