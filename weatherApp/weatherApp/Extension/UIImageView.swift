//
//  UIImageView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Kingfisher

extension UIImageView {
    func setImage(with urlString: String?) {
        if let path = urlString,
           let url = URL(string: path) {
            setImage(with: url)
        } else {
            self.image = Style.Images.placeholder.image
        }
    }
    
    func setImage(with url: URL) {
        kf.setImage(
            with: url,
            placeholder: Style.Images.placeholder.image,
            options: [
                .fromMemoryCacheOrRefresh,
                .diskCacheExpiration(.seconds(3600)),
                .callbackQueue(.mainAsync)
            ])
    }
}
