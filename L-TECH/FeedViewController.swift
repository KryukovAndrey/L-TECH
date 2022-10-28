//
//  FeedViewController.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 27.10.2022.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

private let reuseIdentifier = "Cell"

final class FeedViewController: UIViewController {
    
    // MARK: - Private property
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "По умолчанию"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let buttonImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "arrow_triangle")
        return image
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var articles: [Article] = []
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchDataAF()
    }
    
    // MARK: - Private func
    
    private func configureUI() {
        navigationItem.title = "Лента новостей"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .done, target: self, action: #selector(fetchDataAF))

        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        let stack = UIStackView(arrangedSubviews: [buttonLabel, buttonImage])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        
        view.addSubview(stack)
        stack.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(topBarHeight + 19)
            maker.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(sortButton)
        sortButton.snp.makeConstraints { maker in
            maker.top.equalTo(stack)
            maker.left.equalTo(stack)
            maker.height.equalTo(stack)
            maker.width.equalTo(stack)
        }
        sortButton.addTarget(self, action: #selector(handleSort), for: .touchUpInside)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(sortButton.snp.bottom).offset(19)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
        
    @objc private func fetchDataAF() {
        showLoader(true)
        NetworkManager.fetchDataAF(url: "http://dev-exam.l-tech.ru/api/v1/posts") { articles in
            self.articles = articles
            self.collectionView.reloadData()
            self.showLoader(false)
        }
    }
    
    @objc private func handleSort() {
        print("handleSort")
    }
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailsViewController(article: articles[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.configure(article: articles[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        return CGSize(width: width, height: 119)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
