//
//  NetworkManager.swift
//  PoketBook
//
//  Created by 김석준 on 12/26/24.
//
import Foundation
import RxSwift

class NetworkManager {
    // 싱글톤 인스턴스 생성
    static let shared = NetworkManager()
    
    // private initializer로 외부에서 인스턴스 생성을 막음
    private init() {}
    
    // fetch 메서드 구현
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single<T>.create { single in
            // URLSession을 사용하여 요청 시작
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // 에러 처리
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                // HTTP 응답 상태 코드 확인
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    let statusError = NSError(
                        domain: "NetworkManager",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"]
                    )
                    single(.failure(statusError))
                    return
                }
                
                // 데이터를 디코드
                guard let data = data else {
                    let noDataError = NSError(
                        domain: "NetworkManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No Data Received"]
                    )
                    single(.failure(noDataError))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decodedObject))
                } catch {
                    single(.failure(error))
                }
            }
            
            // 작업 시작
            task.resume()
            
            // 작업 취소 지원
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

