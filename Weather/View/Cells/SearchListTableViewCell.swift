//
//  SearchListTableViewCell.swift
//  Weather
//
//  Created by Aswathy Nair on 3/20/23.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {

    var location: SearchResult?
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityDetailLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    
    /// Display the city, state and country information in cell.
    func configure(location: SearchResult) {
        self.location = location
        self.cityLabel.text = location.name
        self.cityDetailLabel.text = (location.state ) + " " + (location.country)
    }
    
    
}
