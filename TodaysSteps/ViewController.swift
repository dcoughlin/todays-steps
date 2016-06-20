//
//  ViewController.swift
//  TodaysSteps
//
//  Created by Dan Coughlin on 12/3/15.
//  Copyright © 2015 GroovyTree LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: Main view entry point
  
  @IBOutlet weak var stepCountLabel: UILabel!
  let motionManager = MotionManager()
  
  // MARK: Helper methods
  
  func alertPedometerError(msg : String) {
    let alert = UIAlertController(title: "Pedometer Access Error!", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
    alert.addAction(alertAction)
    presentViewController(alert, animated: true) { () -> Void in }
  }
  
  // MARK: Main view entry point
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //-- Force dispatch this to run on the main operation queue
    //   since UI must always run on the main thread
    dispatch_async(dispatch_get_main_queue(), {
      
      // We first need to see if we have permission from the user
      self.motionManager.checkPedometerAuthorization {
        (result, error) -> Void in
        
        // Authorization completion block starts here
        if (result) {
          // Permission given, start live pedometer updates
          self.motionManager.startLivePedometerUpdates {
            (result) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
              self.stepCountLabel.text = "\(result)"  //-- Update view with current step count
            })
          }
        } else {
          // Permission not given or hardware not available
          if let error = error {
            let errMsg = self.motionManager.handleMotionError(error)
            dispatch_async(dispatch_get_main_queue(), {
              self.alertPedometerError(errMsg)
            })
          }
        }
      }
    })
  }
}


