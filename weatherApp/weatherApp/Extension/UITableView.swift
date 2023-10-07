//
//  UITableView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import UIKit
import RxSwift

extension UITableView {
    
    func registerCellClass<T: Reusable>(_ cellType: T.Type) where T: UITableViewCell {
        register(cellType, forCellReuseIdentifier: cellType.reuseID)
    }

    func registerCellNib<T: Reusable>(_ cellType: T.Type) where T: UITableViewCell {
        let nib = UINib(nibName: cellType.reuseID, bundle: Bundle(for: cellType))
        register(nib, forCellReuseIdentifier: cellType.reuseID)
    }

    func dequeueReusableCell<T: Reusable>(
        ofType cellType: T.Type,
        at indexPath: IndexPath
    ) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("❌ Failed attempt create reuse cell \(cellType.reuseID)")
        }
        return cell
    }
    
    func setDataSource(_ dataSource: UITableViewDataSource, delegate: UITableViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

extension UITableView {
    func getScrollToBottomObserver() -> Observable<Void> {
        return self.rx.didScroll
            .filter({ [weak self] _ in
                guard let self = self else { return false }
                
                let offSetY = self.contentOffset.y
                let contentHeight = self.contentSize.height
                return offSetY > (contentHeight - self.frame.size.height - 100)
            })
    }
}
