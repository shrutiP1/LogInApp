
//
//  CustomeCollectionViewCell.swift
//  LoginApp
//
//  Created by gadgetzone on 24/07/21.
//

import UIKit

class CustomeCollectionViewCell: UICollectionViewCell
{
    static let identifier = "CustomeCollectionViewCell"
    public let labell = UILabel()
    public let label2 = UILabel()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(labell)
        addSubview(label2)
        contentView.clipsToBounds = true
       // contentView.layer.cornerRadius = frame.width/2
        layer.cornerRadius = 15
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
 //        backgroundColor = UIColor.white
//         layer.shadowColor = UIColor.gray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        layer.shadowRadius = 2.0
//        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
//        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath


        //Mark: - constraint for label

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews()
    {
        
        labell.frame = CGRect(x: 40,
                              y: 10,
                              width: frame.width,
                              height: 40)
        label2.frame = CGRect(x: 10,
                              y: 20,
                              width: frame.width,
                              height: 70)
        labell.font = UIFont.boldSystemFont(ofSize: 22.0)
        

    }
    
}
