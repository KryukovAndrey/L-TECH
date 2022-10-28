//
//  FavouritesViewController.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 27.10.2022.
//

import Foundation
import UIKit
import SnapKit

final class FavouritesViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
//        imageView.snp.makeConstraints { maker in
//            maker.top.equalToSuperview().inset(20)
//            maker.centerX.equalToSuperview()
//            maker.height.width.equalTo(200)
//        }
    }
}
