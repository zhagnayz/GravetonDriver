//
//  ViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class ViewController: UIViewController{
    
    var iconMenu: [IconMenu] = [IconMenu(icon: UIImage(systemName: "person")!, name: "LogIn")]
    
    enum Sections: Int{
        case sectionOne
        case sectionTwo
    }
    
    var number: String = ""
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        collectionView.register(DriverCell.self, forCellWithReuseIdentifier: DriverCell.reuseIdentifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){
            
            collectionView,indexPath, item in
            
            switch indexPath.section {
            
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DriverCell.reuseIdentifier, for: indexPath) as? DriverCell else {fatalError()}
                
                cell.titleLabel.text = " Login Using:\nPhone Number"
                cell.SubTitleLabel.text = "wee need your Phone Number\n to identify you"
                cell.countryCodeLabel.text = "Phone  +1"
                cell.textField.placeholder = "Enter  Phone  Number"
                cell.textField.delegate = self
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError()}
                
                cell.configureCell(iconMenu: self.iconMenu, indexPath: indexPath)
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
        
        snapShot.appendItems([""],toSection: Sections.sectionOne)
        snapShot.appendItems(iconMenu,toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex,layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
            
            case .sectionOne: return self.createSectionDriver()
                
            case .sectionTwo: return self.createButtonSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        
        layout.configuration = config
        
        return layout
    }
    
    
    func createSectionDriver() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 40, bottom: 0, trailing: 40)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(450))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createButtonSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func didTapLoginButton(){
                     
         let verificationVC = VerificationViewController()
        verificationVC.phoneNumber = number
         navigationController?.pushViewController(verificationVC, animated: false)
     }
}

extension ViewController: UITextFieldDelegate {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if textField == textField{
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)

        }else{
            return true
        }
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{

        
        let indexPath = IndexPath(item: 0, section: 0)
        
        let visibleCell = self.collectionView.cellForItem(at: indexPath) as? DriverCell

        guard let visibleCell = visibleCell else {fatalError()}
        
        if string == ""{ //BackSpace

            return true

        }else if str!.count < 3{

            if str!.count == 1{

                visibleCell.textField.text = "("
            }

        }else if str!.count == 5{

            visibleCell.textField.text = visibleCell.textField.text! + ") "

        }else if str!.count == 10{

            visibleCell.textField.text = visibleCell.textField.text! + "-"

        }else if str!.count > 14{

            return false
        }

        number += string ?? ""
        return true
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            didTapLoginButton()
        }
    }
}
