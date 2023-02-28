//
//  TaskViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

struct Testing: Hashable {
    
    let title: String
    let date: String
    let pickUpOrDrop: String
    let image: UIImage
}

class TaskViewController: UIViewController {
    
    let segmentedController: UISegmentedControl = {
        
        let items = ["Today's Task","All Task"]
        let segmentedController = UISegmentedControl(items: items)
        segmentedController.setWidth(140, forSegmentAt: 0)
        segmentedController.setWidth(140, forSegmentAt: 1)
        return segmentedController
    }()
    
    let arrayTesting = [Testing(title: "Thai Bloom", date: "3/33", pickUpOrDrop: "PickUp", image: UIImage(systemName: "clock")!),Testing(title: "2929 5Th Ave. S. Minneapolis,MN,55408", date: "3/33", pickUpOrDrop: "Drop", image: UIImage(systemName: "clock")!)]
    
    enum Section: Int{
        case section
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section,AnyHashable>?
    
    // Side Menu Bar
    private var sideMenuViewController = AccountViewController()
    private var sideMenuRevealWidth: CGFloat = 420
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false

    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!

    private var revealSideMenuOnTop: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapListDashButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationItem.titleView = segmentedController
    
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.register(DropCell.self, forCellWithReuseIdentifier: DropCell.reuseIdentifier)
        
        setUpSideBarMenu()
        createData()
        reloadData()
    }
    

    func setUpSideBarMenu(){
    
        // Side Menu
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController)
        self.sideMenuViewController.didMove(toParent: self)

        // Side Menu AutoLayout

        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])

    }
    
    @objc func didTapListDashButton(){
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    func createData(){
        
        dataSource = UICollectionViewDiffableDataSource<Section,AnyHashable>(collectionView:collectionView){
            
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
            
            case Section.section.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropCell.reuseIdentifier, for: indexPath) as? DropCell else {fatalError()}

                cell.configureCell(self.arrayTesting , indexPath: indexPath)
                
                if indexPath.item  == 0 {
                    cell.BoxLabel.backgroundColor = .systemBlue
                }else if indexPath.item == 1{
                    cell.BoxLabel.backgroundColor = .orange
                }
                
                
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func didTapDropButton(){
        
        let DropVC = DropViewController()
        navigationController?.pushViewController(DropVC, animated: false)
    }
    
   func didTapPickUpLocationButton(){
        
        let pickUpVC = PickUpViewController()
        navigationController?.pushViewController(pickUpVC, animated: false)
    }
    

    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([Section.section])
        
        snapShot.appendItems(self.arrayTesting,toSection: Section.section)

        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex,layoutEnvironment in
            
            guard let sectionType = Section(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
            
            case .section: return self.createSectionDriver()
            }
        }
        
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//
//        config.interSectionSpacing = 15
//        layout.configuration = config
        
        return layout
    }
    
    
    func createSectionDriver() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
}



extension TaskViewController: SideMenuViewControllerDelegate {
    
    func selectedCell(_ row: Int) {
        
        switch row {
        case 0:
            let taskHiry = TaskHistoryViewController()
            navigationController?.pushViewController(taskHiry, animated: false)
            
        case 1:
            let driverProfileVC = DriverProfileViewController()
            navigationController?.pushViewController(driverProfileVC, animated: false)
        case 3:
            break
        default:
            break
        }

        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }


    func sideMenuState(expanded: Bool) {
        
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}

extension TaskViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            didTapPickUpLocationButton()
        } else if indexPath.item == 1 {
            didTapDropButton()
        }
    }
}
