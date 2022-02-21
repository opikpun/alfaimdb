//
//  MovieInteractor.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

struct MovieInteractor {
    private let bag = DisposeBag()
    
    func getMovieList(page: Int, completion: ((MovieResponse?, Error?) -> Void)?) {
        
        Utils.showLoading()
        
        getProvider.rx
            .request(.getMovieList(page: page))
            .mapModel(MovieResponse.self, keyPath: "")
            .asObservable()
            .subscribe(onNext: { (result) in
                Utils.hideLoading()
                completion?(result, nil)
            }, onError: { (error) in
                Utils.hideLoading()
                completion?(nil, error)
            })
            .disposed(by: bag)
    }
    
    func getMovieVideo(movieId: Int, completion: ((MovieVideoResponse?, Error?) -> Void)?) {
        
        Utils.showLoading()
        
        getProvider.rx
            .request(.getMovieVideo(movieId: movieId))
            .mapModel(MovieVideoResponse.self, keyPath: "")
            .asObservable()
            .subscribe(onNext: { (result) in
                Utils.hideLoading()
                completion?(result, nil)
            }, onError: { (error) in
                Utils.hideLoading()
                completion?(nil, error)
            })
            .disposed(by: bag)
    }
    
    func getMovieReviews(movieId: Int, completion: ((MovieReviewResponse?, Error?) -> Void)?) {
        
        Utils.showLoading()
        
        getProvider.rx
            .request(.getMovieReviews(movieId: movieId))
            .mapModel(MovieReviewResponse.self, keyPath: "")
            .asObservable()
            .subscribe(onNext: { (result) in
                Utils.hideLoading()
                completion?(result, nil)
            }, onError: { (error) in
                Utils.hideLoading()
                completion?(nil, error)
            })
            .disposed(by: bag)
    }
}
