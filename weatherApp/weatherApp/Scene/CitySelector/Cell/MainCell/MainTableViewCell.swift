//
//  CitySelectorTableViewCell.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import RxSwift
import RxCocoa

/// CitySelector screen cell - contains title, history and details buttons
final class CitySelectorTableViewCell: TableViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let historyButton = UIButton()
    private let detailsButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.contentView.frame = self.contentView.frame.inset(by: insets)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    
        contentView.addSubview(containerView)
        
        [titleLabel, historyButton, detailsButton].forEach { view in
            containerView.addSubview(view)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        historyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(detailsButton.snp.left)
            $0.height.equalTo(historyButton.snp.width)
            $0.width.equalTo(24)
        }
        
        detailsButton.snp.makeConstraints {
            $0.centerY.right.equalToSuperview()
            $0.height.equalTo(detailsButton.snp.width)
            $0.width.equalTo(24)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = .clear
        
        titleLabel.textColor = Style.Color.textColor
        titleLabel.font = Style.Font.boldText.withSize(15)
        titleLabel.addCharacterSpacing(kernValue: 2)
        
        detailsButton.setImage(Style.Images.arrowRight.image, for: .normal)
        historyButton.setImage(Style.Images.info.image, for: .normal)
    }
    
    func render(_ model: CitySelectorCellModel) {
        titleLabel.text = model.title
        
        detailsButton.rx.tap
            .bind(to: model.rx.detailsTapEvent)
            .disposed(by: disposeBag)
        historyButton.rx.tap
            .bind(to: model.rx.historyTapEvent)
            .disposed(by: disposeBag)
    }
}
