//
//  ViewController.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import UIKit
import RxSwift

///Base protocol for all view controller
open class ViewController<ViewModel: ViewModelProtocol>: UIViewController,
                                                         ViewProtocol
{
    // MARK: - Properties
    
    public var viewModel: ViewModel!
    
    public let activityIndicatorView = UIActivityIndicatorView()
    
    public lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        
        view.addSubview(spinner)
        
        spinner.center = view.center
        spinner.startAnimating()
        
        return view
    }()
    
    // MARK: - Constructor
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupDeinitAnnouncer()
    }
    
    public init(viewModel: ViewModel,
                nibName: String? = nil,
                bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
        setupDeinitAnnouncer()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDeinitAnnouncer()
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupView()
    }
    
    // MARK: - Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupView()
        setupScrollCollection()
        setupLocalization()
        
        setupOutput()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setupNavigationBar()
    }
    
    // MARK: - Setup Functions
    
    /// Override to setup constraints. Called in viewDidLoad method.
    open func setupConstraints() {}
    
    /// Override to setup views. Called in viewDidLoad method.
    open func setupView() {}
    
    /// Override to setup localization. Called in viewDidLoad method.
    open func setupLocalization() {}
    
    /// Override to setup collection such as UITableView, UICollectionView or etc. Called in viewDidLoad method.
    open func setupScrollCollection() {}
    
    /// Override to setup view navigation bar appereance. Called in viewDidLoad method.
    open func setupNavigationBar() {}
    
    // MARK: - ViewProtocol
    
    open func setupOutput() {}
    
    open func setupInput(input: ViewModel.Output) {}
}

fileprivate enum AssociatedKeys {
    static var disposeBag = "ViewController dispose bag associated key"
}

extension ViewController {
    
    public fileprivate(set) var disposeBag: DisposeBag {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            if let bag = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
                return bag
            } else {
                let bag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, bag, .OBJC_ASSOCIATION_RETAIN)
                return bag
            }
        }
    }
}
