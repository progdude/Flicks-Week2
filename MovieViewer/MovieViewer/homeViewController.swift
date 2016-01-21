//
//  homeViewController.swift
//  MovieViewer
//
//  Created by Archit Rathi on 1/16/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit

class homeViewController: UIViewController {
    
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        slideIn();
        rotateImageView();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        titleLable.frame.origin.x -= view.bounds.width;
        startButton.frame.origin.x += view.bounds.width
        secondLabel.frame.origin.y += view.bounds.height;
        mainImage.frame.origin.y -= view.bounds.height;
        
    }
    
    private func slideIn(){
        UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.titleLable.frame.origin.x += self.view.bounds.width;
            self.startButton.frame.origin.x -= self.view.bounds.width;
            self.secondLabel.frame.origin.y -= self.view.bounds.height;
            self.mainImage.frame.origin.y += self.view.bounds.height;
            
            self.view.layoutIfNeeded()
            }, completion: nil);
    }
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func rotateImageView() {
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.mainImage.transform = CGAffineTransformRotate(self.mainImage.transform, CGFloat(M_PI_2))
            }) { (finished) -> Void in
                if finished {
                    self.rotateImageView()
                }
        }
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}