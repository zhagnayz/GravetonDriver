//
//  TaskViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TaskViewController: UIViewController {
    
    private let emptyValues = Policy(title: "🛒", subTitle: "No Task Assigment Yet", policy: "You have no tasks assigned or your all tasks were completed. We'll notify you when new tasks arrive")
    
    private var num:Int = 0
        
    private lazy var segmentedController: UISegmentedControl = {
        let segmentedConrol = UISegmentedControl(items: ["Today's Task","All Task"])
        segmentedConrol.layer.cornerRadius = 20
        segmentedConrol.layer.borderWidth = 0.5
        segmentedConrol.layer.borderColor = UIColor.tertiarySystemGroupedBackground.cgColor
        segmentedConrol.backgroundColor = .systemBackground
        segmentedConrol.selectedSegmentIndex = 0
        segmentedConrol.addTarget(self, action: #selector(didTapsegmentedController(_:)), for: .valueChanged)
        segmentedConrol.selectedSegmentTintColor = .secondarySystemFill
        segmentedConrol.layer.masksToBounds = true
        return segmentedConrol
    }()
    
    var users:[User] = []
    
    enum Sections: Int{
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    private var sideMenuViewController = AccountViewController()
    private var sideMenuRevealWidth: CGFloat = 420
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var revealSideMenuOnTop: Bool = true
    
    private lazy var adminButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapView), for: .touchDown)
        button.setTitleColor(.clear, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = segmentedController
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapListDashButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: adminButton)
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(DropCell.self, forCellWithReuseIdentifier: DropCell.reuseIdentifier)
        
        collectionView.register(SideMenuCell.self, forCellWithReuseIdentifier: SideMenuCell.reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveUpdate), name: AppDataManager.orderUpdateNotification, object: nil)
        
        setUpSideBarMenu()
        
        createData()
        reloadData()
    }
    
    func createData(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){
            collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropCell.reuseIdentifier, for: indexPath) as? DropCell else {fatalError()}
                
                cell.configureCell(self.users[indexPath.item].driverInfo)
                
                cell.buttonPanelView.completion = { item in
                    
                    switch item {
                    case .minus: self.pickUpFood(indexPath,item.rawValue)
                    case .plus: self.pickUpFood(indexPath,item.rawValue)
                    }
                }
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SideMenuCell.reuseIdentifier, for: indexPath) as? SideMenuCell else {fatalError()}
                
                cell.layer.borderColor = UIColor.clear.cgColor
                
                let value = item as? Policy
                cell.imageLabel.text = value?.title
                cell.titleLabel.text = value?.subTitle
                cell.subTitle.text = value?.policy
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        defer{dataSource?.apply(snapShot)}
        
        snapShot.appendSections([.sectionOne,.sectionTwo])
        
        guard !users.isEmpty else{
            
            snapShot.appendItems([emptyValues],toSection: Sections.sectionTwo)
            return
        }
        
        for user in users {
            snapShot.appendItems([user.driverInfo],toSection: Sections.sectionOne)
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex,layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createSectionDriver()
            case .sectionTwo: return self.createEmptySection()
            }
        }
        return layout
    }
    
    func createSectionDriver() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10)
        layoutSection.interGroupSpacing = 20
        
        return layoutSection
    }
    
    func createEmptySection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: view.frame.size.height/3, leading: 10, bottom: 0, trailing: 10)
        
        return layoutSection
    }
    
    @objc func didTapsegmentedController(_ sender:UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0 {
            sideMenuState(expanded: false)
        }else{
            sideMenuState(expanded: true)
        }
    }
    
    @objc func didReceiveUpdate(){
        
        self.users = []
        self.users = AppDataManager.shared.users
        reloadData()
    }
    
    func setUpSideBarMenu(){
        
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController)
        self.sideMenuViewController.didMove(toParent: self)
        
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
    
    func pickUpFood(_ indexPath:IndexPath,_ item:Int){
        
        let DropVC = DropViewController()
        var user = users[indexPath.item]
        
        if item == 0{
            user.driverInfo?.pickUpOrDrop = "PickUp"
            DropVC.user = user
            navigationController?.pushViewController(DropVC, animated: false)
        }else if item == 1{
            user.driverInfo?.pickUpOrDrop = "Drop"
            DropVC.user = user
            navigationController?.pushViewController(DropVC, animated: false)
            AppDataManager.shared.removeUser(users[indexPath.item])
            collectionView.reloadData()
        }
    }
}

extension TaskViewController: SideMenuViewControllerDelegate {
    
    func selectedCell(_ row: Int) {
        
        switch row {
        case 0: break
        case 1: navigationController?.pushViewController(DriverProfileViewController(), animated: false)
        case 2:
            let taskHistoryVC = TaskHistoryViewController()
            taskHistoryVC.title = "Earnings"
            navigationController?.pushViewController(taskHistoryVC, animated: false)
        case 3: break
        case 4:
     
            let appURL = URL(string: "mailto:daniel-zha@hotmail.com")!

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
            
        default:break
        }
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
    
    func sideMenuState(expanded: Bool) {
        
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
        }else {
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
            }else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        })
    }
    
    @objc func didTapView(){
        
        if num == 5 {
            let cardVC = CardViewController()
            navigationController?.pushViewController(cardVC, animated: false)
            num = 0
        }else{
            num += 1
        }
    }
}
