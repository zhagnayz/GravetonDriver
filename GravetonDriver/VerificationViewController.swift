//
//  VerificationViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class VerificationViewController: UIViewController {
    
    var phoneNumber: String = ""
    let config = UIImage.SymbolConfiguration(pointSize: 20)
    
    enum Section: Int{
        case section
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply",withConfiguration: config)?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.register(CodeVerificationCell.self, forCellWithReuseIdentifier: CodeVerificationCell.reuseIdentifier)
        
        createData()
        reloadData()
    }
    
    
    func createData(){
        
        dataSource = UICollectionViewDiffableDataSource<Section,AnyHashable>(collectionView:collectionView){
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Section.section.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CodeVerificationCell.reuseIdentifier, for: indexPath) as? CodeVerificationCell else {fatalError()}
                
                cell.verificationLabel.text = "Verification"
                cell.CodeInFoLabel.text = "code sent to"
                cell.phoneNumberLabel.text = self.formatPhone(self.phoneNumber)
                cell.NotReceivLabel.text = "Didn't Receive the Code Yet?"
                cell.SendCodeButton.setTitle("Resend Code", for: .normal)
                cell.SendCodeButton.addTarget(self, action: #selector(self.didTapSendCodeButton), for: .touchUpInside)
                cell.button.addTarget(self, action: #selector(self.didTapButtonArrow), for: .touchDown)
                
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([Section.section])
        
        snapShot.appendItems([""],toSection: Section.section)
        
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
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(450))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    @objc func didTapBackButton(){
        
        navigationController?.popToRootViewController(animated: false)
    }
    
    private func formatPhone(_ number: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let format: [Character] = ["X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]
        
        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    @objc func didTapButtonArrow(){
        
        let taskVC = TaskViewController()
        navigationController?.pushViewController(taskVC, animated: false)
    }
    
    @objc func didTapSendCodeButton(){
        
        print("Tap send code Button")
    }
}
