//
//  TitleCollectionViewCell.swift
//  Netflix
//
//  Created by Дмитрий Процак on 02.12.2022.
//

import UIKit
import SDWebImage

final class TitleCollectionViewCell: UICollectionViewCell {
 
    
    static let identifier = "TitleCollectionViewCell"
    
    private lazy var posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }

        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
    
}
