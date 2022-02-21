//
//  MovieListVM.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import RxSwift
import RxCocoa

class MovieListVM {
    
    private let interactor = MovieInteractor()
    private let moviesRelay = BehaviorRelay<[MovieModel]>(value: [])
    private let currentPageRelay = BehaviorRelay<Int>(value: 1)
    private let errorMessageRelay = BehaviorRelay<String?>(value: nil)
   
    
    struct Input {
        let fetchTap: Observable<Void>
        let loadMoreTap: Observable<Void>
    }
    
    struct Output {
        let movies: Driver<[MovieModel]>
        let errorMessage: Driver<String?>
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
    }
    
    func transform(_ input: Input) -> Output {
        self.makeFetch(input)
        self.makeLoadMore(input)
        return Output(movies: moviesRelay.asDriver().skip(1),
                      errorMessage: errorMessageRelay.asDriver().skip(1))
    }
    
    private func makeFetch(_ input: Input) {
        input
            .fetchTap
            .withLatestFrom(currentPageRelay)
            .compactMap { $0 }
            .subscribe(onNext: { (page) in
                self.fetchMovies(page: page)
            }).disposed(by: self.disposeBag)
    }
    
    private func fetchMovies(page: Int){
        self.interactor
            .getMovieList(page: page, completion: { movies, error in
                if let error = error {
                    self.errorMessageRelay.accept(error.localizedDescription)
                    return
                }
                if let movies = movies {
                    self.currentPageRelay.accept(movies.page + 1)
                    self.moviesRelay.accept(movies.results)
                }
            })
    }
    

    private func makeLoadMore(_ input: Input) {
        input
            .loadMoreTap
            .withLatestFrom(currentPageRelay)
            .compactMap { $0 }
            .subscribe(onNext: { (page) in
                self.fetchMovies(page: page)
            }).disposed(by: self.disposeBag)
    }
    
    
}
