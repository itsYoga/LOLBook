//
//  APIManager.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import Foundation

// ApiManager 類別，用於處理 API 請求
struct ApiManager {
    // 泛型方法，從指定的 URL 請求資料並解碼為指定型別 T
    func fetchAPI<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        // 確認 URL 是否有效
        guard let url = url else {
            let error = NetworkError.badUrl // 如果 URL 無效，返回錯誤
            completion(Result.failure(error))
            return
        }

        // 發送網路請求
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 處理 HTTP 回應狀態碼
            if let response = response as? HTTPURLResponse, !(200 ... 299).contains(response.statusCode) {
                // 如果回應狀態碼不是 2xx 範圍，返回對應的錯誤
                completion(Result.failure(NetworkError.response(statusCode: response.statusCode)))
            } else if let error = error as? URLError {
                // 處理 URL 請求錯誤
                completion(Result.failure(NetworkError.urlSession(error)))
            } else if let data = data {
                // 如果有資料，進行解碼
                let decoder = JSONDecoder()
                do {
                    // 嘗試將資料解碼為指定型別 T
                    let result = try decoder.decode(type, from: data)
                    // 解碼成功，返回解碼結果
                    completion(Result.success(result))
                } catch {
                    // 解碼失敗，返回解析錯誤
                    completion(Result.failure(NetworkError.parsing(error as? DecodingError)))
                }
            }
        }
        // 啟動請求任務
        task.resume()
    }
}
