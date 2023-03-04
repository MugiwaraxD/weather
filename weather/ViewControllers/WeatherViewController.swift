//
//  WeatherViewController.swift
//  weather
//
//  Created by Jason Zheng on 3/3/23.
//

import UIKit
import SDWebImage

class WeatherViewController: UIViewController {
    
    private var viewModel: WeatherViewModel?
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Error"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let searchBarPlaceHolder = "Enter city name"
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel?.delegate = self
        viewModel?.loadLastSearchCity()
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchBarPlaceHolder
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        
        // DATA LABELS
        let stackView = UIStackView(arrangedSubviews: [ cityNameLabel, temperatureLabel, humidityLabel, feelsLikeLabel, tempMinLabel, tempMaxLabel,  windLabel, descriptionLabel, weatherImageView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        // ERROR LABEL
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateUI(with weatherData: WeatherData) {
        errorLabel.isHidden = true
        
        cityNameLabel.text = "Current City: \(weatherData.name)"
        temperatureLabel.text = "Current Temp: \(Int(weatherData.main.temp))°F"
        humidityLabel.text = "Humidity: \(weatherData.main.humidity)%"
        feelsLikeLabel.text = "Feels Like: \(Int(weatherData.main.feels_like))°F"
        tempMinLabel.text = "Min Temp: \(Int(weatherData.main.temp_min))°F"
        tempMaxLabel.text = "Max Temp: \(Int(weatherData.main.temp_max))°F"
        windLabel.text = "Wind: \(weatherData.wind.speed) m/s"
        descriptionLabel.text = weatherData.weather.first?.description ?? ""
        if let iconCode = weatherData.weather.first?.icon {
            let iconURLString = "https://openweathermap.org/img/w/\(iconCode).png"
            if let iconURL = URL(string: iconURLString) {
                weatherImageView.sd_setImage(with: iconURL, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
    
    private func hideDataUI() {
        cityNameLabel.isHidden = true
        temperatureLabel.isHidden = true
        humidityLabel.isHidden = true
        feelsLikeLabel.isHidden = true
        tempMinLabel.isHidden = true
        tempMaxLabel.isHidden = true
        windLabel.isHidden = true
        descriptionLabel.isHidden = true
        weatherImageView.isHidden = true
    }
    
    private func showDataUI() {
        cityNameLabel.isHidden = false
        temperatureLabel.isHidden = false
        humidityLabel.isHidden = false
        feelsLikeLabel.isHidden = false
        tempMinLabel.isHidden = false
        tempMaxLabel.isHidden = false
        windLabel.isHidden = false
        descriptionLabel.isHidden = false
        weatherImageView.isHidden = false
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func weatherViewModelDidUpdateData(_ weatherViewModel: WeatherViewModel) {
        if let weatherData = viewModel?.weatherData {
            updateUI(with: weatherData)
            
            showDataUI()
        }
    }
    
    func weatherViewModelDidFailWithError(_ weatherViewModel: WeatherViewModel, error: Error) {
        errorLabel.text = "Error retrieving weather data: \(error.localizedDescription)"
        errorLabel.isHidden = false
        
        hideDataUI()
    }
}

extension WeatherViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let unencodedCity = searchController.searchBar.text, !unencodedCity.isEmpty {
            viewModel?.city = unencodedCity
            hideDataUI()
        }
    }
}
