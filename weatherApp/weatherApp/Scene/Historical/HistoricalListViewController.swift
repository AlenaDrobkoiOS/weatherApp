//
//  HistoricalListViewController.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// Historical screen controller
final class HistoricalViewController: ViewController<BaseHistoricalViewModel> {
    
    // MARK: - UI elements
    
    private let containerView = UIView()
    private let backgroundView = BackgroundView()
    private let headerView = HeaderView()
    private let tableView = UITableView()
    
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
            make.top.equalTo(headerView.snp.bottom).offset(40)
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundView.addImage(Style.Images.background.image)
    }
    
    override func setupScrollCollection() {
        super.setupScrollCollection()
        
        tableView.registerCellClass(HistoricalInfoTableViewCell.self)
        
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
    }
    
    override func setupOutput() {
        super.setupOutput()
        
        let input = BaseHistoricalViewModel.Input(
            backTapped: headerView.leftButton.rx.tap.asObservable(),
            itemSelected: tableView.rx.itemSelected.asObservable(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    override func setupInput(input: BaseHistoricalViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setUpHeaderInfoObserving(with: input.headerInfo, headerView: headerView),
            setUpItemsObserving(with: input.tableItems, tableView: tableView),
            setUpLoadingObserving(with: input.isLoading,
                                  activityIndicatorView: activityIndicatorView)
        )
    }
    
    private func setUpHeaderInfoObserving(with signal: Observable<HeaderInfo>,
                                          headerView: HeaderView) -> Disposable {
        signal
            .subscribe { headerInfo in
                headerView.render(with: headerInfo)
            }
    }
    
    
    private func setUpItemsObserving(with signal: Driver<[HistoricalInfo]>, tableView: UITableView) -> Disposable {
        signal
            .drive(tableView.rx.items) { tableView, row, viewModel in
                let cell = tableView.dequeueReusableCell(
                    ofType: HistoricalInfoTableViewCell.self,
                    at: IndexPath(row: row, section: .zero)
                )
                cell.render(viewModel)
                return cell
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

