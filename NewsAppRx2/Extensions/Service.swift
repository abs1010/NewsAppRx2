////
////  Service.swift
////  NewsAppRx2
////
////  Created by Alan Silva on 07/12/20.
////
//
//import Foundation
//
//enum errorTypes: Error {
//    case noData
//    case cannotProccess
//}
//
//class ApiService {
//    
//    fileprivate let _key = "6ace23c5086742ea849174cf7e33169b"
//    var baseURL = ""
//    
//    init() {
//        self.baseURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(_key)"
//    }
//    
//    func getNews(completion: @escaping(Result<News, errorTypes>) -> Void) {
//        
//        guard let url = URL(string: baseURL) else { return }
//        
//        let session = URLSession(configuration: .default)
//        
//        session.newsTask(with: url) { (data, response, error) in
//            
//            guard let news = data else {
//                completion(.failure(.noData))
//                return
//            }
//            
//            completion(.success(news))
//            
//        }.resume()
//        
//    }
//    
//}
//
//
//// MARK: - Helper functions for creating encoders and decoders
//
//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}
//
//// MARK: - URLSession response handlers
//
//extension URLSession {
//    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        return self.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                completionHandler(nil, response, error)
//                return
//            }
//            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
//        }
//    }
//
//    func newsTask(with url: URL, completionHandler: @escaping (News?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        return self.codableTask(with: url, completionHandler: completionHandler)
//    }
//}
