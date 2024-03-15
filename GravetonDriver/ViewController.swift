//
//  ViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var iconMenu = ["Login","Became Graveton Driver"]
    var placeHolder = ["email","password"]
    var existUsers:[String] = []
    var appIcon = "AppIcon"
    var tempPlaceHolder:[String] = []
    
    var hideOrShowClick = true
    
    private lazy var showOrHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("show", for: .normal)
        button.addTarget(self, action: #selector(didTapHideOrShowButton(_:)), for: .touchUpInside)
        return button
    }()
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = UserDefaults.standard.string(forKey: "email"){
            existUsers = [email,"."]
        }
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
                
        view.addSubview(collectionView)
                
        collectionView.register(FeaturedCircleProducts.self, forCellWithReuseIdentifier: FeaturedCircleProducts.reuseIdentifier)
        
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCircleProducts.reuseIdentifier, for: indexPath) as? FeaturedCircleProducts else {fatalError(FeaturedCircleProducts.reuseIdentifier)}
                
                cell.imageView.image = UIImage(named: (item as? String)!)
                cell.nameLabel.text = "💶 Earn money today. Sign up to become a Graveton Driver in Minutes."
                
                return cell
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError(TextFieldCell.reuseIdentifier)}
                
                if self.existUsers.count > 1 {
                    cell.textField.text = self.existUsers[indexPath.item]
                }else{
                    cell.placeHolderr = self.placeHolder[indexPath.item]
                }

                cell.textField.delegate = self
                
                if indexPath.item == 1{
                    cell.textField.isSecureTextEntry = true
                    cell.textField.rightViewMode = .always
                    cell.textField.rightView = self.showOrHideButton
                }
                
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError(ButtonCell.reuseIdentifier)}
                
                cell.contentView.backgroundColor = .systemBackground
                
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = cell.frame.size.height/2
                
                cell.name.text = item as? String
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        
        snapShot.appendItems([appIcon],toSection: .sectionOne)
        snapShot.appendItems(tempPlaceHolder,toSection: .sectionTwo)
        snapShot.appendItems(iconMenu,toSection: .sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createGravetonSection()
            case .sectionTwo: return self.createTextFieldsSection()
            case .sectionThree: return self.createTextFieldsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func createGravetonSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(190))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 80, leading: 50, bottom: 0, trailing: 50)
        
        return layoutSection
    }
    
    func createTextFieldsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func didTapLoginButton(){
        
        if tempPlaceHolder == []{
            tempPlaceHolder = placeHolder
            reloadData()
            return
        }
                
        var personInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item: item, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            switch item {
                
            case 0: personInfo.email = cell.textField.text!.trimmingCharacters(in: .whitespaces)
            case 1: personInfo.password = cell.textField.text!
                
            default: cell.backgroundColor = .white
            }
        }
        
        if let email = personInfo.email,email.count > 0,let password = personInfo.password,password.count > 0 {
            
            handleLogin(email,password)
        }
    }
    
    func handleLogin(_ email:String,_ password:String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{self.navigationItem.title = error?.localizedDescription
            return
            }
            
            let taskVC =  UINavigationController(rootViewController: TaskViewController())

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
            
            AppDataManager.shared.driverAvailable(result?.user.uid)
            UserDefaults.standard.set(true, forKey: "isUserLogged")
        }
    }

    func didTapRegisterButton(){
         let regiserVC = RegisterViewController()
         navigationController?.pushViewController(regiserVC, animated: false)
     }
    
    @objc func didTapHideOrShowButton(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
        let cell = collectionView.cellForItem(at: IndexPath(item: 1, section: 1)) as? TextFieldCell
        
        cell?.textField.isSecureTextEntry = sender.isSelected

        if sender.isSelected {
            showOrHideButton.setTitle("show", for: .normal)
        }else{
            showOrHideButton.setTitle("hide", for: .normal)
        }
        reloadData()
    }
 
    func isEmailValid(email: String) -> Bool {
        var string = email
        
        if let lastCharacter = email.last?.description {
            if let unicodeValue = UnicodeScalar(lastCharacter) {
                if !CharacterSet.letters.contains(unicodeValue) && !CharacterSet.decimalDigits.contains(unicodeValue) {
                    string = String(string[..<string.index(before: string.endIndex)])
                }
            }
        }
        
        if !string.contains("@") { return false }
        else if string.hasSuffix("gmail.com") { return true }
        else if string.hasSuffix("hotmail.com") { return true }
        else if string.hasSuffix("outlook.com") { return true }
        else if string.hasSuffix("pdx.edu") { return true }
        else if string.hasSuffix("icloud.com") { return true }
        else { return false }
    }
}

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            didTapLoginButton()
        }else if indexPath.section == 2 && indexPath.item == 1 {
            didTapRegisterButton()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        for _ in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item: 0, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            if textField == cell.textField {
                
                guard let email = textField.text else { return false }
                cell.textField.errorMessage = isEmailValid(email: email+string) ? nil : "email must be valid email address"
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item:item , section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            if textField == cell.textField {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}
