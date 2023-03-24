//
//  ImageDownloader.swift
//  Weather
//
//  Created by Aswathy Nair on 3/22/23.
//

import Foundation

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageDownloader: UIImageView {
    
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    
    /// Load image from cache or download from url
    func loadImageWithUrl(_ url: URL) {
        
        // Activity indicator
        self.activityIndicator.color = .lightGray
        
        self.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageURL = url
        
        self.image = nil
        self.activityIndicator.startAnimating()
        
        // Retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            self.activityIndicator.stopAnimating()
            return
        }
        
        // Retrieving image from url as it is not available in cache
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
}
