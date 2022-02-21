//
//  GetService.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import Foundation

import Moya

let getProvider: MoyaProvider<GetService> = {
//    return MoyaProvider<GetService>()
    return MoyaProvider<GetService>(plugins: [NetworkLoggerPlugin()])
}()


enum GetService {
    case getMovieList(page: Int) //using now playing url
    case getMovieVideo(movieId: Int)
    case getMovieReviews(movieId: Int)
}


extension GetService: TargetType {
    var baseURL: URL {
        return URL(string: NetworkConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMovieList:
            return "movie/now_playing"
        case .getMovieVideo(let movieId):
            return "movie/\(movieId)/videos"
        case .getMovieReviews(let movieId):
            return "movie/\(movieId)/reviews"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var params: [String: Any] = ["api_key":NetworkConstant.IMDB_API_KEY]
        
        switch self {
        case .getMovieList(let page):
            params["page"] = page
            break
        default:
            break
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
    }
    
    var headers: [String : String]? {
        return [
            "Accept": "application/json"
        ]
    }
}
