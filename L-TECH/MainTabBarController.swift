//
//  MainTabBarController.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 27.10.2022.
//

import UIKit

final class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    
    private func fetchUser() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        UserService.fecthUser(withUid: uid) { user in
//            self.user = user
//         }
    }
    
    private func checkIfUserIsLoggedIn() {
        
        let phoneNumber = DataManagerAccount.shared.phoneNumber
        let mask = DataManagerAccount.shared.mask
        let password = DataManagerAccount.shared.password

        DispatchQueue.main.async {
            let controller = LoginViewController()
            if phoneNumber != nil,
               mask != nil,
               password != nil {
                controller.phoneNumber = phoneNumber
                controller.mask = mask
                controller.password = password
            }
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private func
    
    private func configureViewController() {
        view.backgroundColor = .white
        
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "icon_home"), selectedImage: #imageLiteral(resourceName: "icon_home"), rootViewController: FeedViewController())
        
        let favourites = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "icon_heart"), selectedImage: #imageLiteral(resourceName: "icon_heart"), rootViewController: FavouritesViewController())
        
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "icon_user"), selectedImage: #imageLiteral(resourceName: "icon_user"), rootViewController: ProfileViewController())
        
        viewControllers = [feed, favourites, profile]
        
        tabBar.items?[0].title = "Главная"
        tabBar.items?[1].title = "Избранное"
        tabBar.items?[2].title = "Аккаунт"
        
        tabBar.tintColor = .blue
        tabBar.barTintColor = .white
    }
    
    private func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        return nav
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
