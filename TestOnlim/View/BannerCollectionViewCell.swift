//
//  BannerCollectionViewCell.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    var name: String = "" {
        
        didSet {
            label.text = name
        }
    }
    
    let label: UILabel = {
        
        let label = UILabel()
        label.font = label.font.withSize(50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var color: String = "" {
        
        didSet {
            
            backgroundColor = hexStringToUIColor(hex: color)
        }
    }
    
    var active: Bool = true
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupCell()
    }
    
    //т.к. мы наследуемся от UICollectionViewCell то нам надо переотпределить инита надо вызвать требуемый инит
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupCell() {
        
        layer.cornerRadius = 50
        
        addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

    }
    
    func settingCellBanner(banner: BannerModel) {
        
        self.name = banner.name
        self.color = banner.color
        self.active = banner.active
        
    }
    
    //функция, которая может преобразовать шестнадцатеричный код RGB в UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
