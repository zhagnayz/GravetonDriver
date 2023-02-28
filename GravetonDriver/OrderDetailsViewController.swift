//
//  OrderDetailsViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    enum Section: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var order: Order? {
        
        return  Order(reference: "B3433", title: "hand to me", date: "3/33", deliveryCharge: 3.99, tip: 9.99, items: [OrderItem(restaurantName: "Thai Bloom", name: "Pad Thai", price: 12.33, details: "fdalskjfalksjdfljkssd", image: "food", quantity: 3, foodIngredient: [FoodIngredient(id: 1, section: "dkd", title: "slkdsd", subTitle: "dsksd", buttonTitle: "", ingredient: [Ingredient(id: 1, name: "chick", quantity: 1, price: 1.33, isSelected: false, isChecked: true)])], te: 3.33)], couponIncluded: false)
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackToHomeButton))
                
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.register(ReceiptTopCell.self, forCellWithReuseIdentifier: ReceiptTopCell.reuseIdentifier)
        
        collectionView.register(CartMenuItemCell.self, forCellWithReuseIdentifier: CartMenuItemCell.reuseIdentifier)
        
        collectionView.register(PriceDetailsCell.self, forCellWithReuseIdentifier: PriceDetailsCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section,AnyHashable>(collectionView: collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
                
            case Section.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceiptTopCell.reuseIdentifier, for: indexPath) as? ReceiptTopCell else {fatalError("\(ReceiptTopCell.reuseIdentifier)")}
                cell.backgroundColor = .tertiarySystemGroupedBackground

                cell.configureReceipt(self.order!)
                
                return cell
                
            case Section.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartMenuItemCell.reuseIdentifier, for: indexPath) as? CartMenuItemCell else {fatalError("\(CartMenuItemCell.reuseIdentifier)")}
                
                cell.backgroundColor = .tertiarySystemGroupedBackground
                //cell.configureMenuItem(self.order!.items, indexPath: indexPath)
                
                cell.imageView.image = UIImage(named: self.order!.items[indexPath.item].image)
                cell.nameLabel.text = self.order!.items[indexPath.item].name
                cell.priceLabel.text = "\(self.order!.items[indexPath.item].formattedPrice)"
                
                var name: String = ""
                
                for item in self.order!.items[indexPath.item].foodIngredient {
                    
                    for iten in item.ingredient {
                        
                        if iten.isSelected == true {
                            
                            name += "\(iten.name),"
                        }
                    }
                }
                
                cell.proteinLabel.text = name
                
                cell.detailTitleLabel.text = "Adds On"
                
                var addedItem: String = ""
                
                for item in self.order!.items[indexPath.item].foodIngredient  {
                    
                    for iten in item.ingredient {
                        
                        if iten.isChecked == true {
                            
                            addedItem += "\(iten.name),"
                        }
                    }
                }
                
                cell.priceDetailLabel.text = "\(self.order!.items[indexPath.item].formattedPrice)\(self.order!.items[indexPath.item].formattedQuantity) = "
                
                cell.priceLabel.text = "\(String(format: "$%.2f", self.order!.items[indexPath.item].totalPrice))"

                cell.detailLabel.text = addedItem
                                
                return cell
                
            case Section.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceDetailsCell.reuseIdentifier, for: indexPath) as? PriceDetailsCell else {fatalError("\(PriceDetailsCell.reuseIdentifier)")}
                
                cell.backgroundColor = .tertiarySystemGroupedBackground

                cell.configurePricceDetail(self.order!)

                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree,])
        
        snapShot.appendItems([""],toSection: Section.sectionOne)
        snapShot.appendItems(order!.items,toSection: Section.sectionTwo)
        snapShot.appendItems([order],toSection: Section.sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, layoutEnvironment in
            
            guard let section = Section(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case Section.sectionOne: return self.createReceiptSection()
                
            case Section.sectionTwo: return self.createSelectedItemsSection()
                
            case Section.sectionThree: return self.createOrderDetailsSection()
                
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
    
    func createReceiptSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createSelectedItemsSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createOrderDetailsSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }

    @objc func didTapBackToHomeButton(){
        navigationController?.popViewController(animated: true)
    }
}

extension OrderDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

