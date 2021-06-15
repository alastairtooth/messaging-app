//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) //running this just allows the Superclass to run what it may want to before we run what we've got in our class.  This is a good habit to get into when doing override functions, however in this case does nothing.
        
        //this code hides the navigation bar just before the WelcomeViewController loads
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) //as per the above
        
        //this code brings the navigation bar back just before the WelcomeViewController segues somewhere else
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        //WAY TO DESIGN TEXT ANIMATION - could have also used cocoapods CLTypeLabel instead
        titleLabel.text = ""
        var charIndex = 0.0 //creates delay in each letter so they appear incrementally after each other.  Needs to be a double for timer.  If this isn't done then the timer runs after 0.1 seconds for all letters at once.
        let titleText = K.appName
        for letter in titleText {

            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
       
    }
    

}
