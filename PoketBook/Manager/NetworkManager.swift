import Foundation
import RxSwift

final class NetworkManager {
    // MARK: - Singleton Instance
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Fetch Method
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Handle errors
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                // Check HTTP response status code
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    single(.failure(NetworkError.invalidResponse))
                    return
                }
                
                // Decode the response data
                guard let data = data else {
                    single(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decodedData))
                } catch {
                    single(.failure(NetworkError.decodingFailed(error)))
                }
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}

// MARK: - NetworkError Definition
enum NetworkError: Error {
    case invalidResponse
    case noData
    case decodingFailed(Error)
    case invalidURL
    case decodingError
    case requestFailed
}
