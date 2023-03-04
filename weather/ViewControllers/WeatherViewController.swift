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
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter city name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
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
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [cityTextField, temperatureLabel, humidityLabel, feelsLikeLabel, tempMinLabel, tempMaxLabel,  windLabel, descriptionLabel, weatherImageView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private func updateUI(with weatherData: WeatherData) {
        temperatureLabel.text = "\(Int(weatherData.main.temp - 273.15))°C"
        humidityLabel.text = "Humidity: \(weatherData.main.humidity)%"
        windLabel.text = "Wind: \(weatherData.wind.speed) m/s"
        descriptionLabel.text = weatherData.weather.first?.description ?? ""
        if let iconCode = weatherData.weather.first?.icon {
            let iconURLString = "https://openweathermap.org/img/w/\(iconCode).png"
            if let iconURL = URL(string: iconURLString) {
                weatherImageView.sd_setImage(with: iconURL, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
    
    private func hideUI() {
        temperatureLabel.isHidden = true
        humidityLabel.isHidden = true
        windLabel.isHidden = true
        descriptionLabel.isHidden = true
        weatherImageView.isHidden = true
    }
    
    private func showUI() {
        temperatureLabel.isHidden = false
        humidityLabel.isHidden = false
        windLabel.isHidden = false
        descriptionLabel.isHidden = false
        weatherImageView.isHidden = false
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func weatherViewModelDidUpdateData(_ weatherViewModel: WeatherViewModel) {
        if let weatherData = viewModel?.weatherData {
            updateUI(with: weatherData)
            showUI()
        }
    }
    
    func weatherViewModelDidFailWithError(_ weatherViewModel: WeatherViewModel, error: Error) {
        hideUI()
                let errorLabel = UILabel()
                errorLabel.font = UIFont.systemFont(ofSize: 18)
                errorLabel.text = "Error retrieving weather data: \(error.localizedDescription)"
                errorLabel.numberOfLines = 0
                errorLabel.textAlignment = .center
                errorLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(errorLabel)
                
                NSLayoutConstraint.activate([
                    errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
    }
    
    
}
