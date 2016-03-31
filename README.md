# GmailStyleAnimation
This demonstrate the profile presentation and animation of image and user details into navigationbar

![giphy](https://github.com/avadeshyadav/GmailStyleAnimation/blob/master/Files/SampleAnimation.gif)

You are permitted to use, modify or do anything you want from this code at your own risk. I will not be reponsible for any kind of harm or loss. 


To start integrating this in your project:

Step 1: Put a UICollectionView, as I have added in Main.storyboard with class ProfilViewController.


Step 2: For Background fade-in transistion, Use the method 
        
        addSemiTransparentViewAnimationInBackGround()

In your View Controller, as I have done in ProfilViewController.


Step 3: With your collectionview delegate and datasource methods implement UIScrollView Delegate method named:

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

Step 4: For better code seperation, all the animation related code is written in ProfileImageCell class.

Code is self explainatry, then also if you need any kind of help, you are most welcome and please feel free to contact me on mail id: send2er.avadesh@gmail.com


