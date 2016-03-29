//
//  ProfilViewController.swift
//  AnimationSample
//
//  Created by Avadesh Kumar on 17/03/16.
//  Copyright © 2016 ibibo Group. All rights reserved.
//

let navigationBarOffset: CGFloat = 64
let profileImageCellHeight: CGFloat = 380
let numberOfCells: Int = 7
let bgViewAlpha: CGFloat = 0.7

import UIKit

class ProfilViewController: UIViewController, UIScrollViewDelegate, ProfileImageCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgSemiTransparentView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addSemiTransparentViewAnimationInBackGround()
        configureNavigationBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bgSemiTransparentView.hidden = false
    }
    
    //MARK: Private Methods
    func configureNavigationBar() {

        self.navigationController?.navigationBar.hidden = true

        let image = UIImage(named: "ic_share_grey.png")
        let imageView = UIImageView(frame: CGRectMake(0, 0, 36, 36))
        imageView.image = image
        imageView.userInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "shareButtonPressed")
        imageView.addGestureRecognizer(tapGesture)
        
        let shareButton = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItems = [shareButton]
    }
    
    func shareButtonPressed() {
    
        let alertController = UIAlertController(title: "Awesome", message: "You pressed share button", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Enjoy", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // This is the additional view to show shadow animation in background while this view controller presentation is in progres, it will be removed automatically after completion of animation.
    func addSemiTransparentViewAnimationInBackGround() {
        
        let superView = self.presentingViewController?.view
        
        if superView == nil {
            return
        }
        
        let marginToStartView: CGFloat = 30
        bgSemiTransparentView.alpha = bgViewAlpha
        
        let backgroundView =  UIView(frame: CGRectMake((superView!.frame.origin.x + marginToStartView), superView!.frame.origin.y + marginToStartView, superView!.frame.size.width - marginToStartView * 2, superView!.frame.size.height - marginToStartView * 2))
        
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0.0
        
        superView?.addSubview(backgroundView)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            backgroundView.frame = superView!.frame
            backgroundView.alpha = bgViewAlpha
            })
            { (completed) -> Void in
                backgroundView.removeFromSuperview()
        }
    
    }
    
    //MARK: Collection View DataSource & Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numberOfCells;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell: UICollectionViewCell;
        
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileImageCell", forIndexPath: indexPath) as! ProfileImageCell
            (cell as! ProfileImageCell).delegate = self
            (cell as! ProfileImageCell).configureCellWithDetails()
        }
        else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserDetailsCell", forIndexPath: indexPath) as! UserDetailsCell
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var height: CGFloat = profileImageCellHeight
        
        if indexPath.row != 0 {
            height = 110
        }
        
        return CGSizeMake(collectionView.frame.size.width, height)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
                
        if (scrollView.contentOffset.y < -100) {// To dismiss view controller if user has swiped down
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? ProfileImageCell
        
        if cell != nil {
            //We just replace the current view with navigationbar if content has gone behind navigationbar offset and vice versa in else condition
            if ((scrollView.contentOffset.y + navigationBarOffset) > profileImageCellHeight) {
                
                self.navigationController?.navigationBar.hidden = false
                self.navigationItem.titleView = cell?.getNavigationBarHeaderView()
            }
            else {
                cell?.doConfigurationForContentOffsetY(scrollView.contentOffset.y)
                self.navigationController?.navigationBar.hidden = true
            }
        }
    }
    
    //MARK: ProfileImageCell delegate methods
    func didPressedShareButtonOnCell(cell: ProfileImageCell) {
        self.shareButtonPressed()
    }
    
    func didTappedBackgroundOnCell(cell: ProfileImageCell) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTappedImageViewOnCell(cell: ProfileImageCell) {
        print("Show profile picture")
    }
}
