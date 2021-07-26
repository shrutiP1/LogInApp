
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
        contentView.backgroundColor = UIColor.white
       contentView.addSubview(labell)
      contentView.addSubview(label2)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews()
    {
        
        labell.frame = CGRect(x: 10,
                              y: 10,
                              width: contentView.frame.width,
                              height: 40)
        label2.frame = CGRect(x: 10,
                              y: 20,
                              width: contentView.frame.width,
                              height: 70)
        labell.font = UIFont.boldSystemFont(ofSize: 22.0)
        

    }
    
}
