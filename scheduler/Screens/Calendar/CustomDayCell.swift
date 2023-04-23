//
//  CustomDayCell.swift
//  scheduler
//
//  Created by Collin Qian on 4/22/23.
//

import Foundation
import UIKit

final class CustomDayCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(origin: .zero, size: frame.size)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
