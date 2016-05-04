//
//  ProfileImageCell.swift
//  AnimationSample
//
//  Created by Avadesh Kumar on 17/03/16.
//  Copyright © 2016 ibibo Group. All rights reserved.
//

import UIKit

protocol ProfileImageCellDelegate {
    func didPressedShareButtonOnCell(cell: ProfileImageCell)
    func didTappedBackgroundOnCell(cell: ProfileImageCell)
    func didTappedImageViewOnCell(cell: ProfileImageCell)
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
    var imageViewOriginalFrame: CGRect = CGRectZero
    var imageViewTransformedFrame: CGRect = CGRectZero

    
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
        
        imageViewTransformedFrame = CGRectMake(20, 20, 40, 40)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 1.5
        
        let tapGestureToDismiss = UITapGestureRecognizer(target: self, action: "tappedOnBackgroundView")
        bgTapToDismissView.addGestureRecognizer(tapGestureToDismiss)
        
        let tapGestureOnImageView = UITapGestureRecognizer(target: self, action: "tappedOnUserProfileImageView")
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureOnImageView)
    }
    
    func tappedOnBackgroundView() {
        self.delegate?.didTappedBackgroundOnCell(self)
    }
    
    func tappedOnUserProfileImageView() {
        self.delegate?.didTappedImageViewOnCell(self)
    }
    
    //MARK: IBAction Methods
    @IBAction func actionShareButtonPressed(sender: AnyObject) {
        self.delegate?.didPressedShareButtonOnCell(self)
    }
    
    //MARK: Public Methods
    func getNavigationBarHeaderView() -> UIView {
    
        let view = UIView(frame: CGRectMake(0,0, self.frame.size.width - 60, 44))
         let imageView = UIImageView(frame: CGRectMake(view.frame.size.width * 0.053, 0, imageViewTransformedFrame.size.width, imageViewTransformedFrame.size.height))
        imageView.image = profileImageView.image
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 1.5
        
        var label = UILabel(frame: CGRectMake( (self.frame.size.width - nameLabel.frame.size.width) / 2 - 8, 3, nameLabel.frame.size.width, nameLabel.frame.size.height))
        label.text = nameLabel.text
        label.font = nameLabel.font
        label.textAlignment = nameLabel.textAlignment
        label.textColor = nameLabel.textColor
        
        view.addSubview(label)
        
        label = UILabel(frame: CGRectMake((self.frame.size.width - nameLabel.frame.size.width) / 2 - 8, label.frame.origin.y + (detailsLabel.frame.origin.y - nameLabel.frame.origin.y), detailsLabel.frame.size.width, detailsLabel.frame.size.height))
        label.text = detailsLabel.text
        label.font = detailsLabel.font
        label.textAlignment = detailsLabel.textAlignment
        label.textColor = detailsLabel.textColor

        view.addSubview(label)

        view.addSubview(imageView)
        
        return view
    }
    
    func doConfigurationForContentOffsetY(offsetY: CGFloat) {
        
        var frame: CGRect = self.profileImageView.frame;
        var headerViewFrame: CGRect = self.headerBarView.frame
        
        if imageViewOriginalFrame == CGRectZero {
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