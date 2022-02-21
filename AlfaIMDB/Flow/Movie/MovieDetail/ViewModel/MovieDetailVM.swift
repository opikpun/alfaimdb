//
//  MovieDetailVM.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import RxSwift
import RxCocoa

class MovieDetailVM {
    
    private let interactor = MovieInteractor()
    private let movieVideoRelay = BehaviorRelay<MovieVideoModel?>(value: nil)
    private let movieReviewRelay = BehaviorRelay<[MovieReviewModel]>(value: [])
    private let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    
    
    private let disposeBag = DisposeBag()
    
    init() {
    }
    
    struct Input {
        let fetchVideoTap: Observable<Void>
        let fetchReviewsTap: Observable<Void>
        let movieId: Observable<Int>
    }
    
    struct Output {
        let movieVideo: Driver<MovieVideoModel?>
        let movieReviews: Driver<[MovieReviewModel]>
        let errorMessage: Driver<String?>
    }
    
    
    func transform(_ input: Input) -> Output {
        self.makeFetchMovieVideo(input)
        self.makeFetchMovieReviews(input)
        return Output(movieVideo: movieVideoRelay.asDriver().skip(1),
                      movieReviews: movieReviewRelay.asDriver().skip(1),
                      errorMessage: errorMessageRelay.asDriver().skip(1))
    }
    
    private func makeFetchMovieVideo(_ input: Input) {
        input
            .fetchVideoTap
            .withLatestFrom(input.movieId)
            .compactMap { $0 }
            .subscribe(onNext: { (movieId) in
                self.fetchMovieVideo(input: input, movieId: movieId)
            }).disposed(by: self.disposeBag)
    }
    
    
    private func fetchMovieVideo(input:Input, movieId: Int){
        self.interactor
            .getMovieVideo(movieId: movieId, completion: { movies, error in
                if let error = error {
                    self.errorMessageRelay.accept(error.localizedDescription)
                    return
                }
                if let movie = movies?.results.filter({ $0.type == "Trailer" && $0.site == "YouTube" }).first {
                    self.movieVideoRelay.accept(movie)
                }
                self.makeFetchMovieReviews(input)
            })
    }
    
    private func makeFetchMovieReviews(_ input: Input) {
        input
            .fetchVideoTap
            .withLatestFrom(input.movieId)
            .compactMap { $0 }
            .subscribe(onNext: { (movieId) in
                self.fetchMovieReviews(movieId: movieId)
            }).disposed(by: self.disposeBag)
    }
    
    
    private func fetchMovieReviews(movieId: Int){
        self.interactor
            .getMovieReviews(movieId: movieId, completion: { reviews, error in
                if let error = error {
                    self.errorMessageRelay.accept(error.localizedDescription)
                    return
                }
                self.movieReviewRelay.accept(reviews?.results ?? [])
            })
    }
}
