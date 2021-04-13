//
//  ApiClient.swift
//  BitnetVehicle
//
//  Created by József Jagicza on 2021. 04. 08..
//

import Foundation
import RxSwift
import RxCocoa

class APIClient {
    private let baseURL = URL(string: "https://vpic.nhtsa.dot.gov/api/vehicles/getallmanufacturers")!

    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
            return Observable<T>.create { observer in
                let request = apiRequest.request(with: self.baseURL)
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    do {
                        let model: Vehicles = try JSONDecoder().decode(Vehicles.self, from: data ?? Data())
                        observer.onNext( model.results as! T)
                    } catch let error {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
    
    /*
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        let request = apiRequest.request(with: baseURL)
        return URLSession.shared.rx.data(request: request)
            .map {
                try JSONDecoder().decode(T.self, from: $0)
            }
    }
 */
}
