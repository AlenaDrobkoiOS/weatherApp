//
//  HeaderView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit

/// Header View - contains title, right and left side button
final class HeaderView: View {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    let rightButton = SideButton()
    let leftButton = SideButton()
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(rightButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(leftButton)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rightButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        leftButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        titleLabel.font = Style.Font.boldText.withSize(17)
        titleLabel.textColor = Style.Color.textColor
        titleLabel.addCharacterSpacing(kernValue: 2)
        titleLabel.textAlignment = .center
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
    }
    
    func render(with model: HeaderInfo) {
        titleLabel.text = model.title
        rightButton.sideButtonState = model.rightButtonState
        leftButton.sideButtonState = model.leftButtonState
    }
}
