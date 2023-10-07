//
//  WeatherDetailInfoView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit

/// WeatherDetailInfoView - contains detail info about weather
final class WeatherDetailInfoView: View {
    
    private let stackView = UIStackView()
    
    private let weatherImage = UIImageView()
    
    private let descriptionInfo = DoubleTextView()
    private let temperatureInfo = DoubleTextView()
    private let humidityInfo = DoubleTextView()
    private let windSpeedInfo = DoubleTextView()
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.addSubview(stackView)
        [weatherImage, descriptionInfo, temperatureInfo, humidityInfo, windSpeedInfo]
            .forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.8)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        self.backgroundColor = .white
        self.addShadowAndRadius(shadowOpacity: 0.05, cornerRadius: 30)

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
    }
    
    func render(with model: WeatherDetailInfoViewModel) {
        weatherImage.setImage(with: model.iconURL)
        
        descriptionInfo.render(with: .init(title: Localizationable.Global.description.localized,
                                           value: model.description))
        temperatureInfo.render(with: .init(title: Localizationable.Global.temperature.localized,
                                           value: model.temperature))
        humidityInfo.render(with: .init(title: Localizationable.Global.humidity.localized,
                                        value: model.humidity))
        windSpeedInfo.render(with: .init(title: Localizationable.Global.windspeed.localized,
                                         value: model.windSpeeped))
    }
}
