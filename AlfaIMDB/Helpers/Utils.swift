//
//  Utils.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import Foundation
import NVActivityIndicatorView


class Utils{
    public static func showLoading() {
        let activityData = ActivityData.init(size: CGSize.init(width: 35, height: 35), type: NVActivityIndicatorType.ballGridPulse, color: UIColor.primaryRed, backgroundColor: .black.withAlphaComponent(0.3))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    public static func hideLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    public static func showErrorMessage(message: String, presenter: UIViewController, handler: (() -> Void)?) {
        
        let alertController = UIAlertController(title: "Oops", message: "No Internet Connection", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Reload", style: .default) { action in
            handler?()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        presenter.present(alertController, animated: true, completion: nil)
    }
}
