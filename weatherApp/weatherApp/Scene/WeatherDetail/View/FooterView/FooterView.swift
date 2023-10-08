//
//  FooterView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit

/// Footer View - contains info about date and origin
final class FooterView: View {
    private let stackView = UIStackView()
    private let infoLabel = UILabel()
    private let dateLabel = UILabel()
    
    override func setupConstraints() {
        super.setupConstraints()
        
        addSubview(stackView)
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(dateLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        [infoLabel, dateLabel].forEach { label in
            label.font = Style.Font.regularSmallText
            label.textColor = Style.Color.textColor
            label.textAlignment = .center
            label.numberOfLines = 0
        }
    }
    
    func render(with model: FooterViewInfo) {
        infoLabel.text = Localizationable.Global.footerText.localized
            .replacingOccurrences(of: "CITY", with: model.city)
        dateLabel.text = model.date.getString()
    }
}
