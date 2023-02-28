//
//  SideMenuViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    func selectedCell(_ item: Int)
}

class AccountViewController: UIViewController {
    
    var iconMenu: [IconMenu] = [
        IconMenu(icon: UIImage(systemName: "house.fill")!, name: "Home"),
        IconMenu(icon: UIImage(systemName: "film.fill")!, name: "Movies"),
        IconMenu(icon: UIImage(systemName: "book.fill")!, name: "Books"),
        IconMenu(icon: UIImage(systemName: "person.fill")!, name: "Profile"),
        IconMenu(icon: UIImage(systemName: "slider.horizontal.3")!, name: "Settings"),
        IconMenu(icon: UIImage(systemName: "hand.thumbsup.fill")!, name: "Like us on facebook")]
    
    
    var logout: [IconMenu] = [IconMenu(icon: UIImage(systemName: "person")!, name: "logout")]
    
    var collectionView: UICollectionView!
    
    enum Sections: Int {
        
        case sectionOne
        case sectionTwo
    }
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My Account"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositinLayout())
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        collectionView.delegate = self
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError("Unable to dequeue")}
                
                cell.configureCell(iconMenu: self.iconMenu, indexPath: indexPath)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError("Unable to dequeue fooder cell")}
                cell.configureCell(iconMenu: self.logout, indexPath: indexPath)
                cell.backgroundColor = .systemBackground
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 6
                
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        snapShot.appendItems(iconMenu, toSection: Sections.sectionOne)
        snapShot.appendItems(logout, toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex, layoutEnvironment in
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
            
            case .sectionOne: return self.iconMenuSecion()
                
            case .sectionTwo: return self.logOutSection()
                
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        config.interSectionSpacing = 45
        layout.configuration = config
        
        return layout
    }
    
    func iconMenuSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 20
    
        
        return layoutSection
    }
    
    func logOutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func didTapLogoutButton(){
        
        UserDefaults.standard.set(false, forKey: "isUserLogged")
        
        let loginNavController = UINavigationController(rootViewController: ViewController())
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}

extension AccountViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if indexPath.section == 0 {
            self.delegate?.selectedCell(indexPath.item)
        }else if indexPath.section == 1 {
            didTapLogoutButton()
        }
    }
}
