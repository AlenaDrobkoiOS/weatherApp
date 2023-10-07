//
//  DoubleTextView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit

/// DoubleTextView - contains title and description
final class DoubleTextView: View {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        titleLabel.font = Style.Font.boldText.withSize(12)
        titleLabel.textColor = Style.Color.textColor
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        valueLabel.font = Style.Font.boldText.withSize(20)
        valueLabel.textColor = .tintColor
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 1
    }
    
    func render(with model: DoubleTextViewInfo) {
        titleLabel.text = model.title
        valueLabel.text = model.value
    }
}
