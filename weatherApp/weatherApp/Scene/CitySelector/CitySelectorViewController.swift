//
//  CitySelectorViewController.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// CitySelector screen controller
final class CitySelectorViewController: ViewController<BaseCitySelectorViewModel> {
    
    // MARK: - UI elements
    
    private let containerView = UIView()
    private let backgroundView = BackgroundView()
    private let headerView = HeaderView()
    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        
        view.addSubview(spinner)
        
        spinner.center = view.center
        spinner.startAnimating()
        
        return view
    }()
    
    // MARK: - Set Up VC
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        view.addSubview(containerView)
        [backgroundView, headerView, tableView, activityIndicatorView]
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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupView() {
        super.setupView()
        headerView.render(with:
                .init(title: Localizationable.Global.cityTitle.localized,
                      rightButtonState: .right))
    }
    
    override func setupScrollCollection() {
        super.setupScrollCollection()
        
        tableView.registerCellClass(CitySelectorTableViewCell.self)
        
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
    }
    
    override func setupOutput() {
        super.setupOutput()
        
        let input = BaseCitySelectorViewModel.Input(
            addTapped: headerView.rightButton.rx.tap.asObservable(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    override func setupInput(input: BaseCitySelectorViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setUpItemsObserving(with: input.tableItems, tableView: tableView),
            setUpLoadingObserving(with: input.isLoading,
                                  activityIndicatorView: activityIndicatorView)
        )
    }
    
    private func setUpItemsObserving(with signal: Driver<[CitySelectorCellModel]>, tableView: UITableView) -> Disposable {
        signal
            .drive(tableView.rx.items) { tableView, row, viewModel in
                let cell = tableView.dequeueReusableCell(
                    ofType: CitySelectorTableViewCell.self,
                    at: IndexPath(row: row, section: .zero)
                )
                cell.render(viewModel)
                return cell
            }
    }
    
    private func setUpFooterStateObserving(with signal: Observable<Bool>, tableView: UITableView, viewSpinner: UIView) -> Disposable {
        signal
            .subscribe { isAvaliable in
                guard let isAvaliable = isAvaliable.element else { return }
                tableView.tableFooterView = isAvaliable ? viewSpinner : UIView(frame: .zero)
            }
    }
    
    private func setUpLoadingObserving(with signal: Observable<Bool>, activityIndicatorView: UIActivityIndicatorView) -> Disposable {
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
}
