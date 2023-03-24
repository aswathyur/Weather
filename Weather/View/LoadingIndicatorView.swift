//
//  LoadingIndicatorView.swift
//  Weather
//
//  Created by Aswathy Nair on 3/20/23.
//

import UIKit


@objc protocol LoadingIndicatorDelegate: AnyObject {
    func addLoadingIndicator()
}

class LoadingIndicatorView: UIView {
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private var activityStackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewIdentifier: String?
    weak var delegate: LoadingIndicatorDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicatorView.style = .medium
    }
    
    /// Displays the loading indicator on UI with animation
    func startAnimating(title: String = "Loading", viewIdentifier: String? = nil) {
        self.isHidden = false
        self.activityStackView.isHidden = false
        self.errorLabel.isHidden = true
        self.loadingLabel.text = title
        self.activityIndicatorView.startAnimating()
        self.viewIdentifier = viewIdentifier
    }
    
    /// Stop the animation and hide it
    func stopAnimating() {
        if self.errorLabel.isHidden {
            self.isHidden = true
            self.activityIndicatorView.stopAnimating()
            self.viewIdentifier = nil
        }
    }
    
    /// Shows the error message on UI if any api call fails.
    func showErrorText(text: String?) {
        self.activityStackView.isHidden = true
        self.isHidden = false
        self.errorLabel.text = text
        self.errorLabel.isHidden = false
    }
    
    class func instanceFromNib() -> LoadingIndicatorView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingIndicatorView
    }
}
