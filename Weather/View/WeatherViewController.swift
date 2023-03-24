//
//  WeatherViewController.swift
//  Weather
//
//  Created by Aswathy Nair on 3/17/23.
//

import UIKit
import Combine

@MainActor
class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var loadingIndicatorView: LoadingIndicatorView!
    
    ///View model
    var viewModel = WeatherViewModel()
    
    /// Search bar
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by city"
        return searchController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the navigation bar
        self.title = "Weather"
        self.navigationItem.searchController = self.searchController
        
        // Add loding indicator to the view
        self.addLoadingIndicator()
        
        // Register the table view cells
        self.registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch last saved location if any
        self.viewModel.fetchSavedLocation()
        
        // Show loading indicator if view is still loading
        if self.viewModel.isLoading {
            self.loadingIndicatorView.startAnimating()
        }
    }
    
    /// Notifies the view controller that a segue is about to be performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherDetailViewSegue" {
            let navController = segue.destination as! UINavigationController
            let weatherDetailViewController = navController.topViewController as! WeatherDetailViewController
            weatherDetailViewController.viewModel = WeatherDetailViewModel()
            weatherDetailViewController.viewModel.location = self.viewModel.selectedLocation
        }
    }
    
    /// Register the custom UITableViewCells
    private func registerCell() {
    
        // Register the search results cell
        let searchResultsCell = UINib(nibName: "SearchListTableViewCell", bundle: nil)
        self.tableView.register(searchResultsCell, forCellReuseIdentifier: "SearchListTableViewCell")
        
        // Register the cell to show the weather of last saved location
        let weatherCell = UINib(nibName: "WeatherCell", bundle: nil)
        self.tableView.register(weatherCell, forCellReuseIdentifier: "WeatherCellIdentifier")
        
        // Call back from the view model
        viewModel.reloadUI = {[weak self] in
            self?.tableView.reloadData()
            self?.loadingIndicatorView.stopAnimating()
        }
    }
    
}

// MARK: - UITableView delegates and datasource
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If view is loading return 0 else, res
        if !self.viewModel.isLoading {
            if WeatherViewSections(rawValue: section) == .selectedLocation {
                if self.viewModel.savedLocationWeather != nil {
                    return 1
                }
            } else {
                return self.viewModel.searchResults.count
            }
        }
        // Default no of rows
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherViewSections.allCases.count
    }
    
    /// Last saved loacation is shown currently. If time permits I would have let the user to add multiple locations to the dashboard and allow the user to remove it also. If I proceed with that plan will move the search results to different serach results controller.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.viewModel.isLoading {
            // Selected location cell
            if WeatherViewSections(rawValue: indexPath.section) == .selectedLocation {
                if let cell: WeatherCell = self.tableView.dequeueReusableCell(withIdentifier: "WeatherCellIdentifier") as? WeatherCell {
                    cell.detailedWeather = self.viewModel.savedLocationWeather
                    return cell
                }
            } else {
                if let cell: SearchListTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell") as? SearchListTableViewCell {
                    if viewModel.searchResults.count > indexPath.row, let location = viewModel.searchResults[indexPath.row] {
                        cell.configure(location: location)
                    }
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if WeatherViewSections(rawValue: section) == .searchResults {
            return "Search Results"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.viewModel.isLoading {
            return
        }
        // Selected loaction
        if WeatherViewSections(rawValue: indexPath.section) == .selectedLocation {
            self.viewModel.selectedLocation = self.viewModel.lastSavedLocation
            self.performSegue(withIdentifier: "weatherDetailViewSegue", sender: self)
        }
        else { // Search results cell
            if let location = viewModel.searchResults[indexPath.row] {
                self.viewModel.selectedLocation = location
                self.performSegue(withIdentifier: "weatherDetailViewSegue", sender: self)
            }
        }
    }
    
}

// MARK: - Search bar delegates
extension WeatherViewController: UISearchBarDelegate {
    
    /// Search when text changes in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.performSearch(text: searchText)
    }
}

// MARK: - Loading Indicator delegates
extension WeatherViewController: LoadingIndicatorDelegate {
    
    /// Add loading indicator to the view
    func addLoadingIndicator() {
        self.loadingIndicatorView = LoadingIndicatorView.instanceFromNib()
        self.loadingIndicatorView.delegate = self
        self.view.addSubview(self.loadingIndicatorView)
        self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.loadingIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loadingIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
