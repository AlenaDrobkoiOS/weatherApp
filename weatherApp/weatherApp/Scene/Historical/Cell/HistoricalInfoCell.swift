//
//  HistoricalInfoCell.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import RxSwift
import RxCocoa

/// HistoricalInfo cell - contains date and weather description
final class HistoricalInfoTableViewCell: TableViewCell {
    
    private let containerView = UIView()
    private let infoView = DoubleTextView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        infoView.render(with: .init())
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        contentView.frame = contentView.frame.inset(by: insets)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        contentView.addSubview(containerView)
        containerView.addSubview(infoView)
        
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        infoView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = .clear
    }
    
    func render(_ model: HistoricalInfo) {
        infoView.render(with: .init(state: .vertical,
                                    title: model.date.getString(),
                                    value: model.weatherInfo.description + ", " + model.weatherInfo.temperature))
    }
}

