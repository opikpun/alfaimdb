//
//  MovieListViewController.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import Reachability

class MovieListViewController: UIViewController {
    
    let viewModel: MovieListVM = MovieListVM()
    var reachability = try! Reachability()
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.registerNib(forCell: MovieItemCell.self)
        }
    }
    
    private var fetchRelay = PublishRelay<Void>()
    private var loadMoreRelay = PublishRelay<Void>()
    private var pageRelay = BehaviorRelay<Int>(value: 0)

    private let disposeBag = DisposeBag()
    
    private var movies:[MovieModel] = []

    private var onLoad = false
    private var canLoadMore = true
    
    private var sizeCell: CGSize = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? reachability.startNotifier()
        
        self.setupView()
        self.bindViewModel()
        
        self.onLoad = true
        self.fetchRelay.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Movie List"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = " "
        reachability.stopNotifier()
    }
    
    func setupView() {
        
        let width = (UIScreen.main.bounds.size.width - 30.0) / 2.0
        let height = 123.0/82.0 * width
        
        self.sizeCell = CGSize(width: width, height: height)
    }
    
    func bindViewModel() {
        let input = MovieListVM.Input(fetchTap: self.fetchRelay.asObservable(),
                                        loadMoreTap: self.loadMoreRelay.asObservable())
        let output = self.viewModel.transform(input)
        output.movies.drive(onNext: { (movies) in
            self.movies.append(contentsOf: movies)
            self.onLoad = false
            self.canLoadMore = movies.count != 0
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
        
        reachability.rx.isReachable
            .subscribe(onNext: { [weak self] (status) in
                if !status {
                    self?.showError(message: "No Internet Connection")
                }
            })
            .disposed(by: self.disposeBag)
        
        output.errorMessage.drive(onNext: { (errorMessage) in
            if let errorMessage = errorMessage {
                self.showError(message: errorMessage)
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func showError(message: String) {
        Utils.showErrorMessage(message: message, presenter: self) {
            self.fetchRelay.accept(())
        }
    }

}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieItemCell.self), for: indexPath) as! MovieItemCell
        
        let movie = movies[indexPath.row]
        
        cell.movieNameLabel.text = movie.title
        cell.starLabel.text = "\(movie.voteAverage)"
        if let url = URL(string: NetworkConstant.smallImageURL + movie.posterPath) {
            cell.movieImageView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastData = self.movies.count - 1
        if !onLoad && indexPath.row == lastData && canLoadMore {
            onLoad = true
            self.loadMoreRelay.accept(())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        
        let vc = MovieDetailViewController()
        vc.movie = movie
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
