//
//  MovieDetailViewController.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerNib(forCell: MovieReviewCell.self)
            tableView.registerNib(forCell: MovieDetailHeaderCell.self)
            tableView.registerNib(forCell: MovieVideoCell.self)
            tableView.registerNib(forCell: MovieReviewHeaderCell.self)
        }
    }
    
    var movie:MovieModel!
    
    let viewModel: MovieDetailVM = MovieDetailVM()
    
    private var fetchVideoRelay = PublishRelay<Void>()
    private var fetchReviewsRelay = PublishRelay<Void>()
    private var movieIdRelay = BehaviorRelay<Int>(value: 0)
    
    
    private var contents:[Any] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let movie = movie {
            self.contents.append(movie)
            self.title = movie.title
        }
        
        self.bindViewModel()
        
        self.movieIdRelay.accept(movie.id)
        self.fetchVideoRelay.accept(())
    }
    
    func bindViewModel() {
        let input = MovieDetailVM.Input(
            fetchVideoTap: self.fetchVideoRelay.asObservable(),
            fetchReviewsTap: self.fetchReviewsRelay.asObservable(),
            movieId: self.movieIdRelay.asObservable())
        
        let output = self.viewModel.transform(input)
        
        output.movieVideo.drive(onNext: { (video) in
            if let video = video {
                self.contents.append(video)
                self.tableView.reloadData()
            }
            
        }).disposed(by: self.disposeBag)
        
        output.movieReviews.drive(onNext: { (reviews) in
            if reviews.count > 0 {
                self.contents.append("REVIEW")
                self.contents.append(contentsOf: reviews)
                self.tableView.reloadData()
            }
            
        }).disposed(by: self.disposeBag)
        
        output.errorMessage.drive(onNext: { (errorMessage) in
            if let errorMessage = errorMessage {
                Utils.showErrorMessage(message: errorMessage, presenter: self) {
                    self.fetchVideoRelay.accept(())
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
}

extension MovieDetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = contents[indexPath.row]
        
        if let movie = item as? MovieModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailHeaderCell.self)) as! MovieDetailHeaderCell
            
            cell.movieTitleLabel.text = movie.originalTitle
            
            var usePosterImageAsBackdrop = false
            if let url = URL(string: NetworkConstant.originalImageURL + (movie.backdropPath ?? "")) {
                cell.backdropImageView.sd_setImage(with: url, completed: nil)
            } else {
                usePosterImageAsBackdrop = true
            }
            
            if let url = URL(string: NetworkConstant.originalImageURL + movie.posterPath) {
                cell.posterImageView.sd_setImage(with: url, completed: nil)
                if usePosterImageAsBackdrop {
                    cell.backdropImageView.sd_setImage(with: url, completed: nil)
                }
            }
            
            cell.movieYearLabel.text = "(" + (movie.releaseDate.date(format: "yyyy-MM-dd")?.string(format: "Y") ?? "") + ")"
            
            cell.movieStarLabel.text = "\(movie.voteAverage)"
            cell.movieOverviewLabel.text = movie.overview
            return cell
            
        } else if let video = item as? MovieVideoModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieVideoCell.self)) as! MovieVideoCell
            
            cell.ytPlayerView.load(withVideoId: video.key)
            return cell
        } else if let review = item as? MovieReviewModel {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieReviewCell.self)) as! MovieReviewCell
            
            cell.authorNameLabel.text = review.author
            
            var strPath = review.authorDetails.avatarPath ?? ""
            if strPath.prefix(1) == "/" {
                strPath = String(strPath.dropFirst())
            }
            
            if let url = URL(string: strPath) {
                cell.avatarImageView.sd_setImage(with: url, completed: nil)
            } else {
                cell.avatarImageView.image = #imageLiteral(resourceName: "default-avatar")
            }
            
            cell.contentLabel.text = review.content
            
            return cell
        } else if item is String {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieReviewHeaderCell.self)) as! MovieReviewHeaderCell
            return cell
        }
        return UITableViewCell()
    }
}
