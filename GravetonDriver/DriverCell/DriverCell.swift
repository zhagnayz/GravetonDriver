//
//  DriverCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class DriverCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "DriverCell"
    
    var LogoView: TestingSpinnerView!
    
    let logoLabel: UILabel = {

        let logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        logoLabel.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        logoLabel.text = "Graveton"
        logoLabel.textAlignment = .center
        return logoLabel
    }()
    
    let titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        return titleLabel
    }()
    
    let SubTitleLabel: UILabel = {
        
        let SubTitleLabel = UILabel()
        SubTitleLabel.numberOfLines = 0
        SubTitleLabel.textColor = .gray
        return SubTitleLabel
    }()
    
    let textField: UITextField = {
        
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let horizontalSeparator = UIView(frame: .zero)
    let verticalSeparator = UIView(frame: .zero)
    
    let countryCodeLabel: UILabel = {
        let countryCodeLabel = UILabel()
        countryCodeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return countryCodeLabel
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        LogoView = TestingSpinnerView(frame: CGRect(x: contentView.frame.size.width/5, y: 5, width: 250, height: 250))
        
        horizontalSeparator.backgroundColor = .quaternaryLabel
        verticalSeparator.backgroundColor = .quaternaryLabel
        
        LogoView.addSubview(logoLabel)
        
        contentView.addSubview(LogoView)
        
        let stackViewOne = UIStackView(arrangedSubviews: [countryCodeLabel,verticalSeparator,textField])
        stackViewOne.distribution = .fillProportionally
        stackViewOne.spacing = 6
        
        let stackViewTwo = UIStackView(arrangedSubviews: [stackViewOne,horizontalSeparator])
        stackViewTwo.axis = .vertical
        stackViewTwo.spacing = 5
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,SubTitleLabel,stackViewTwo])
        stackView.axis = .vertical
        stackView.spacing = 30
        
       // LogoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            verticalSeparator.widthAnchor.constraint(equalToConstant: 3),
            horizontalSeparator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
        
        stackView.setCustomSpacing(40, after: LogoView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestingSpinnerView : UIView {
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 1
        setPath()
    }
    
    override func didMoveToWindow() {
        animate()
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }
    
    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.0),
                Pose(0.6, 0.000, 0.0),
                Pose(0.6, 0.000, 0.0),
                Pose(0.6, 0.500, 0.0),
                Pose(0.2, 0.000, 0.0),
                Pose(0.2, 0.000, 0.0),
                Pose(0.2, 0.500, 0.0),
                Pose(0.2, 0.000, 0.0),
            ]
        }
    }
    
    func animate() {
        
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 0.5 * .pi)
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
        
        animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        
        let count = 1
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        animation.values = (0 ... count).map {
            UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 1).cgColor
        }
        
        animation.duration = duration
        animation.calculationMode = .linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}
