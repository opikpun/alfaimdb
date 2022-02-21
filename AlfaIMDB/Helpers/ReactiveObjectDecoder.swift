//
//  ReactiveObjectDecoder.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import Foundation
import RxSwift
import Moya

private let errorDomain = "error.alfaimdb.com"

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    private func decodingError() -> NSError {
        return NSError(domain: errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Decoding process has failed."])
    }
    
    func filterStatusCode() -> Single<Response> {
        return flatMap { (response) -> Single<Response> in
            do {
                if (response.statusCode == 200 || response .statusCode == 201) {
                    return .just(response)
                } else {
                    let error = NSError(
                        domain: errorDomain,
                        code: response.statusCode,
                        userInfo: ["message":"Something Wrong"]
                    )
                    return .error(error)
                }
            } catch {
                return .error(error)
            }
        }
    }

    
    func mapModel<T: Decodable>(_ type: T.Type, keyPath: String = "") -> Single<T> {
         return filterStatusCode()
            .flatMap({ (response) -> PrimitiveSequence<SingleTrait, T> in
                do  {
                    let decoder = JSONDecoder()
                    let finalResult = try decoder.decode(T.self, from: response.data)
                    
                    return .just(finalResult)
                } catch {
                    return .error(self.decodingError())
                }
                
            })
    }
    
}
