//
//  FeedCell.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 27.10.2022.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

final class FeedCell: UICollectionViewCell {
    
    // MARK: - Private property
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let detailTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(article: Article) {
        titleLabel.text = article.title
        detailTextLabel.text = article.text
        dateLabel.text = DateManager.timeMessage(time: article.date)
        
        guard let extraUrlString = article.image else { return }
        let urlString = "http://dev-exam.l-tech.ru" + extraUrlString
        let url = URL(string: urlString)
        imageView.kf.setImage(with: url)
        
//        print("---------------------------")
//        print(article.title)
//        print(urlString)
    }
    
    private func configureUI() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(16)
            maker.top.equalToSuperview().inset(21)
            maker.width.height.equalTo(80)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(imageView.snp.right).offset(16)
            maker.top.equalToSuperview().inset(21)
            maker.right.equalToSuperview()
        }
        titleLabel.numberOfLines = 0
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { maker in
            maker.left.equalTo(imageView.snp.right).offset(16)
            maker.bottom.equalToSuperview().inset(16)
        }
        
        addSubview(detailTextLabel)
        detailTextLabel.snp.makeConstraints { maker in
            maker.left.equalTo(imageView.snp.right).offset(16)
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.bottom.equalTo(dateLabel.snp.top)
            maker.right.equalToSuperview().inset(16)
        }
        detailTextLabel.numberOfLines = 2
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { maker in
            maker.height.equalTo(1)
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().inset(16)
            maker.right.equalToSuperview()
        }
        separatorView.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
    }
}
