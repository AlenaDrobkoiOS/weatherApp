//
//  WeatherDetailController.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// WeatherDetail screen controller
final class WeatherDetailViewController: ViewController<BaseWeatherDetailViewModel> {
    
    // MARK: - UI elements
    
    private let containerView = UIView()
    private let backgroundView = BackgroundView()
    private let headerView = HeaderView()
    private let detailsView = WeatherDetailInfoView()
    private let footerView = FooterView()
    
    private var dismissed = PublishSubject<Void>()
    
    // MARK: - Set Up VC
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed {
            dismissed.onNext(())
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        view.addSubview(containerView)
        [backgroundView, headerView, detailsView, footerView, activityIndicatorView]
            .forEach { view in
                containerView.addSubview(view)
            }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        detailsView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.lessThanOrEqualTo(footerView.snp.bottom)
        }
        
        footerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundView.addImage(Style.Images.background.image)
    }
    
    override func setupOutput() {
        super.setupOutput()
        
        let input = BaseWeatherDetailViewModel.Input(
            dismissTapped: headerView.leftButton.rx.tap.asObservable(),
            dismissed: dismissed.asObserver(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    override func setupInput(input: BaseWeatherDetailViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setUpHeaderInfoObserving(with: input.headerInfo, headerView: headerView),
            setUpLoadingObserving(with: input.isLoading,
                                  activityIndicatorView: activityIndicatorView),
            setUpWeatherDetailInfoObserving(with: input.detailInfo, detailsView: detailsView),
            setUpFooterViewInfoObserving(with: input.footerInfo, footerView: footerView)
        )
    }
    
    private func setUpLoadingObserving(with signal: Observable<Bool>,
                                       activityIndicatorView: UIActivityIndicatorView) -> Disposable {
        signal
            .subscribe { isLoading in
                guard let isLoading = isLoading.element else { return }
                if isLoading {
                    activityIndicatorView.startAnimating()
                } else {
                    activityIndicatorView.stopAnimating()
                }
            }
    }
    
    private func setUpHeaderInfoObserving(with signal: Observable<HeaderInfo>,
                                          headerView: HeaderView) -> Disposable {
        signal
            .subscribe { headerInfo in
                headerView.render(with: headerInfo)
            }
    }
    
    private func setUpFooterViewInfoObserving(with signal: Observable<FooterViewInfo>,
                                              footerView: FooterView) -> Disposable {
        signal
            .subscribe { footerInfo in
                footerView.render(with: footerInfo)
            }
    }
    
    private func setUpWeatherDetailInfoObserving(with signal: Observable<WeatherDetailInfoViewModel>,
                                                 detailsView: WeatherDetailInfoView) -> Disposable {
        signal
            .subscribe { model in
                detailsView.render(with: model)
            }
    }
}
