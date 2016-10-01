//
//  ProfileImageCell.swift
//  AnimationSample
//
//  Created by Avadesh Kumar on 17/03/16.
//  Copyright © 2016 ibibo Group. All rights reserved.
//

import UIKit

protocol ProfileImageCellDelegate {
    func didPressedShareButtonOnCell(_ cell: ProfileImageCell)
    func didTappedBackgroundOnCell(_ cell: ProfileImageCell)
    func didTappedImageViewOnCell(_ cell: ProfileImageCell)
}

class ProfileImageCell : UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerBarView: UIView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgTapToDismissView: UIView!
    
    //MARK: Public variables
    var delegate: ProfileImageCellDelegate?
    
    var cellHeight: CGFloat = 0
    var imageViewOriginalFrame: CGRect = CGRect.zero
    var imageViewTransformedFrame: CGRect = CGRect.zero

    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfigurations()
    }
    
    //MARK: Public Methods
    func configureCellWithDetails() {
    }
    
    //MARK: Private Methods
    func doInitialConfigurations() {
       
        self.layoutIfNeeded()
        cellHeight =  self.contentView.frame.size.height
        
        imageViewTransformedFrame = CGRect(x: 20, y: 20, width: 40, height: 40)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 1.5
        
        let tapGestureToDismiss = UITapGestureRecognizer(target: self, action: #selector(ProfileImageCell.tappedOnBackgroundView))
        bgTapToDismissView.addGestureRecognizer(tapGestureToDismiss)
        
        let tapGestureOnImageView = UITapGestureRecognizer(target: self, action: #selector(ProfileImageCell.tappedOnUserProfileImageView))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureOnImageView)
    }
    
    func tappedOnBackgroundView() {
        self.delegate?.didTappedBackgroundOnCell(self)
    }
    
    func tappedOnUserProfileImageView() {
        self.delegate?.didTappedImageViewOnCell(self)
    }
    
    //MARK: IBAction Methods
    @IBAction func actionShareButtonPressed(_ sender: AnyObject) {
        self.delegate?.didPressedShareButtonOnCell(self)
    }
    
    //MARK: Public Methods
    func getNavigationBarHeaderView() -> UIView {
    
        let view = UIView(frame: CGRect(x: 0,y: 0, width: self.frame.size.width - 60, height: 44))
         let imageView = UIImageView(frame: CGRect(x: view.frame.size.width * 0.053, y: 0, width: imageViewTransformedFrame.size.width, height: imageViewTransformedFrame.size.height))
        imageView.image = profileImageView.image
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.5
        
        var label = UILabel(frame: CGRect( x: (self.frame.size.width - nameLabel.frame.size.width) / 2 - 8, y: 3, width: nameLabel.frame.size.width, height: nameLabel.frame.size.height))
        label.text = nameLabel.text
        label.font = nameLabel.font
        label.textAlignment = nameLabel.textAlignment
        label.textColor = nameLabel.textColor
        
        view.addSubview(label)
        
        label = UILabel(frame: CGRect(x: (self.frame.size.width - nameLabel.frame.size.width) / 2 - 8, y: label.frame.origin.y + (detailsLabel.frame.origin.y - nameLabel.frame.origin.y), width: detailsLabel.frame.size.width, height: detailsLabel.frame.size.height))
        label.text = detailsLabel.text
        label.font = detailsLabel.font
        label.textAlignment = detailsLabel.textAlignment
        label.textColor = detailsLabel.textColor

        view.addSubview(label)

        view.addSubview(imageView)
        
        return view
    }
    
    func doConfigurationForContentOffsetY(_ offsetY: CGFloat) {
        
        var frame: CGRect = self.profileImageView.frame;
        var headerViewFrame: CGRect = self.headerBarView.frame
        
        if imageViewOriginalFrame == CGRect.zero {
            imageViewOriginalFrame = frame;
        }
        
        if (offsetY > (imageViewOriginalFrame.origin.y - imageViewTransformedFrame.origin.y)) {
            
            if offsetY < cellHeight {
                let originX = (cellHeight - offsetY) * ((imageViewOriginalFrame.origin.x - imageViewTransformedFrame.origin.x) / (cellHeight - imageViewOriginalFrame.origin.y))
                
                let ratio: CGFloat = ((imageViewOriginalFrame.origin.x - imageViewTransformedFrame.origin.x) / (imageViewOriginalFrame.size.width - imageViewTransformedFrame.size.width))
                let width: CGFloat = (cellHeight - offsetY) * 0.66//ratio
                
                frame.size.width = width
                frame.size.height = width
                frame.origin.x = CGFloat(originX)
            }
            
            frame.origin.y = offsetY + imageViewTransformedFrame.origin.y;
        }
         else {
            frame = imageViewOriginalFrame;
        }
        
        if offsetY >  headerBarView.superview!.frame.origin.y {
            headerViewFrame.origin.y  = offsetY -  headerBarView.superview!.frame.origin.y
        }
        else {
            headerViewFrame.origin.y = 0;
        }
        
        self.headerBarView.frame = headerViewFrame
        
        profileImageView.frame = frame;
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2

    }
}
