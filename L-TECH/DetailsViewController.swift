//
//  DetailsViewController.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 28.10.2022.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

final class DetailsViewController: UIViewController {
    
    // MARK: - Private property
        
    var article: Article?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let detailTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Life Cycle

    init(article: Article) {
        super.init(nibName: nil, bundle: nil)
        self.article = article
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureData()
    }
    
    // MARK: - Private func
    
    private func configureUI() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let likeButton   = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_heart"),  style: .plain, target: self, action: nil)
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_share_ios"),  style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [shareButton, likeButton]
        
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(topBarHeight + 19)
            maker.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(19)
            maker.left.right.equalToSuperview().inset(16)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(dateLabel.snp.bottom).offset(8)
            maker.left.right.equalToSuperview().inset(16)
        }
        titleLabel.numberOfLines = 0

        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(32)
            maker.left.right.equalToSuperview().inset(16)
            let width = view.frame.width - 32
            maker.width.equalTo(width)
            maker.height.equalTo(width * 0.66)
        }
        
        scrollView.addSubview(detailTextLabel)
        detailTextLabel.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).offset(32)
            maker.left.right.equalToSuperview().inset(16)
            maker.bottom.equalToSuperview().inset(16)
        }
        detailTextLabel.numberOfLines = 0
    }
    
    private func configureData() {
        guard let article = article else { return }
        titleLabel.text = article.title
        detailTextLabel.text = article.text
        dateLabel.text = DateManager.timeMessage(time: article.date)
        
        guard let extraUrlString = article.image else { return }
        let urlString = "http://dev-exam.l-tech.ru" + extraUrlString
        let url = URL(string: urlString)
        imageView.kf.setImage(with: url)
    }
}
