//
//  PickUpViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class PickUpViewController: UIViewController{
    
    
    var inFoButton: [IconMenu] = [IconMenu(icon: UIImage(systemName: "location")!, name: "Navigate"),IconMenu(icon: UIImage(systemName: "note.text")!, name: "Order details")]

    enum Sections: Int {
        
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?

    var floatingButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Hold to start", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    let config = UIImage.SymbolConfiguration(pointSize: 20)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward",withConfiguration: config)?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.register(ClientInfoCell.self, forCellWithReuseIdentifier: ClientInfoCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        collectionView.register(TaskDetailsCell.self, forCellWithReuseIdentifier: TaskDetailsCell.reuseIdentifier)

        collectionView.delegate = self
        
        createDataSource()
        reloadData()
        

        view.addSubview(floatingButton)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(long))
        
         self.floatingButton.addGestureRecognizer(longPress)
       // floatingButton.addTarget(self, action: #selector(normalButtonTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([

            floatingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func long(gesture: UILongPressGestureRecognizer) {
        
        if let label = gesture.view as? UIButton {
            
            if gesture.state == .began {
                //label.titleLabel?.textColor = UIColor.red
            }
            
            if gesture.state == .ended {
                label.setTitle("Hold to arrive", for: .normal)
                gesture.view?.backgroundColor = .orange
            }
        }
    }

    
    //
//     @objc func normalButtonTap(sender: UIButton) {
//         print("Button tapped")
//     }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
        
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientInfoCell.reuseIdentifier, for: indexPath) as? ClientInfoCell else {fatalError("Unable to Deque \(ClientInfoCell.reuseIdentifier)")}
                
                cell.configureCell()
                cell.BoxLabel.text = "Pick Up"
                cell.addressLabel.text = "Thai Bloom"
                cell.phoneLabel.text = "(612) - 234- 3434"
                cell.emailLabel.text = "Zhagnayz@pdx.edu"
                cell.dateLabel.text = "3/33/32"
                     
                return cell
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError("Unable to Deque \(ButtonCell.reuseIdentifier)")}
            
                cell.configureCell(iconMenu: self.inFoButton, indexPath: indexPath)
                
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 6
                
                if indexPath.item == 0 {
                    cell.backgroundColor = .systemBlue
                }else{
                    cell.backgroundColor = .systemGreen
                }
                
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskDetailsCell.reuseIdentifier, for: indexPath) as? TaskDetailsCell else {fatalError("Unable to Deque \(TaskDetailsCell.reuseIdentifier)")}
            
                cell.taskDetailLabel.text = "Task Details"
                cell.emailLabel.text = "Zhagnayz@pdx.edu"
                cell.phoneLabel.text = "(612) 343-3434"
                cell.dateLabel.text = "Feb 3/3/3"
                cell.taskLabel.text = "Task Reference"
                cell.restLabel.text = "order from Thai Bloom"
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo,Sections.sectionThree])
        snapShot.appendItems([""],toSection: Sections.sectionOne)
        snapShot.appendItems(inFoButton,toSection: Sections.sectionTwo)
        snapShot.appendItems(["jjj"],toSection: Sections.sectionThree)

        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            
            sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
            
            case Sections.sectionOne: return self.createProteinSection()
            case .sectionTwo: return self.ButtonsSection()
            case .sectionThree: return self.tastDetailsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        config.interSectionSpacing = 20
        
        layout.configuration = config
        
        return layout
    }
    
    func createProteinSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(330))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func ButtonsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        return layoutSection
    }
    
    
    func tastDetailsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        return layoutSection
    }

    @objc func didTapBackButton(){
        
        navigationController?.popViewController(animated: false)
    }
}


extension PickUpViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.section == 1 && indexPath.item == 0 {
            
        }else if indexPath.section == 1 && indexPath.item == 1 {
            
            let orderDetailsVC = OrderDetailsViewController()
            navigationController?.pushViewController(orderDetailsVC, animated: false)
        }
    }
}
