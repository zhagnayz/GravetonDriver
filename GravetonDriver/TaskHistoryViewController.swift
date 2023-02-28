//
//  TaskHistoryViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class TaskHistoryViewController: UIViewController {

    enum Section: Int{
        
        case section
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Task History"
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(TaskHistoryCell.self, forCellWithReuseIdentifier: TaskHistoryCell.reuseIdentifier)
        
        createData()
        reloadData()
        
    }
    
    func createData(){
        
        dataSource = UICollectionViewDiffableDataSource<Section,AnyHashable>(collectionView:collectionView){
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
            
            case Section.section.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskHistoryCell.reuseIdentifier, for: indexPath) as? TaskHistoryCell else {fatalError()}
                
                cell.taskView.addressLabel.text = "Thai Bloom"
                cell.cashToCollectLabel.text = "Cash to be Collected: 40.00"
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.setLocalizedDateFormatFromTemplate("MMMdYYYYhm")
                cell.taskView.dateLabel.text = dateFormatter.string(from: Date())
                cell.taskView.dropButton.setTitle("PickUp", for: .normal)
                cell.taskView.dropButton.backgroundColor = .systemBlue
                cell.taskView.CashLabel.text = "45.00"
                cell.taskView.imageView.image = UIImage(systemName: "clock")
                cell.taskView.dollarSignImage.image = UIImage(systemName: "dollarsign.circle")

                return cell
    
            default:
                return UICollectionViewCell()
            }
        }
    }
    

    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([Section.section])
        
        snapShot.appendItems(["uy"],toSection: Section.section)

        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex,layoutEnvironment in
            
            guard let sectionType = Section(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
            
            case .section:
                return self.createSectionDriver()
            }
        }
        
        return layout
    }
    
    func createSectionDriver() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
}
    

