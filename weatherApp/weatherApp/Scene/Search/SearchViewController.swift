//
//  SearchViewController.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// Search screen controller
final class SearchViewController: ViewController<BaseSearchViewModel> {
    
    // MARK: - UI elements
    
    private let containerView = UIView()
    private let backgroundView = BackgroundView()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
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
        [backgroundView, searchBar, tableView, activityIndicatorView]
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
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.showsCancelButton = true
        
        searchBar.rx.cancelButtonClicked
            .bind { [weak self] _ in
                self?.searchBar.text = ""
        }
        .disposed(by: disposeBag)
        
        searchBar.placeholder = Localizationable.Global.search.localized
        searchBar.prompt = Localizationable.Global.searchInfo.localized
    }
    
    override func setupScrollCollection() {
        super.setupScrollCollection()
        
        tableView.registerCellClass(CityTableViewCell.self)
        
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
    }
    
    override func setupOutput() {
        super.setupOutput()
        
        let input = BaseSearchViewModel.Input(
            cancelTapped: searchBar.rx.cancelButtonClicked.asObservable(),
            citySelected: tableView.rx.itemSelected.asObservable(),
            textUpdated: searchBar.rx.searchButtonClicked
                .map({ return self.searchBar.text }).asObservable(),
            dismissed: dismissed.asObserver(),
            disposeBag: disposeBag)
        
        viewModel.transform(input, outputHandler: setupInput(input:))
    }
    
    override func setupInput(input: BaseSearchViewModel.Output) {
        super.setupInput(input: input)
        
        disposeBag.insert(
            setUpItemsObserving(with: input.tableItems, tableView: tableView),
            setUpLoadingObserving(with: input.isLoading,
                                  activityIndicatorView: activityIndicatorView)
        )
    }
    
    private func setUpItemsObserving(with signal: Driver<[CityCellModel]>, tableView: UITableView) -> Disposable {
        signal
            .drive(tableView.rx.items) { tableView, row, viewModel in
                let cell = tableView.dequeueReusableCell(
                    ofType: CityTableViewCell.self,
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
