//
//  MotionManager.swift
//  TodaysSteps
//
//  Created by Dan Coughlin on 12/6/15.
//  Copyright © 2015 GroovyTree LLC. All rights reserved.
//

import UIKit
import CoreMotion

class MotionManager {
  // MARK - Global & private properties
  
  let pedometer = CMPedometer()  //-- Static pedometer object to access all services
  
  // MARK - Check Pedometer Autorization
  
  /** This method will trigger a UI diaglog asking the user for
  Motion & Fitness Activity access on 1st use. Make sure it runs
  off the main operation queue!
  */
  func checkPedometerAuthorization(completionHandler: (result: Bool, error: NSError?) -> Void)
  {
    //-- We don't care about return value, just whether there is error,
    //-- so just set both dates to now
    let now = NSDate()
    
    pedometer.queryPedometerDataFromDate(now, toDate: now) {
      (data: CMPedometerData?, error) -> Void in
      
      if error != nil {
        completionHandler(result: false, error: error)
      } else {
        completionHandler(result: true, error: nil)
      }
    }
    
  }
  
  // MARK: Error Handling
  
  /** Convert CMMotionActivity Error into user msg.
  */
  func handleMotionError(error: NSError) -> String {
    var errMsg : String
    
    switch error.code {
    case Int(CMErrorMotionActivityNotAvailable.rawValue):
      errMsg = "Motion Coprocessor not installed on this device"
    case Int(CMErrorMotionActivityNotAuthorized.rawValue):
      errMsg = "Fitness & Motion Activity permision deined"
    default:
      errMsg = "Unexpected error code:\(error.code)"
    }
    
    return errMsg
  }
  
  
  // MARK: Live Activity Updates
  
  /** This method should be used to start monitoring live peometer updates.
  */
  func startLivePedometerUpdates(completionHandler: (result: Int) -> Void) -> Bool {
    var updatesAvailable = true
    
    // If step counting is available, start pedometer updates from now going forward.
    if CMPedometer.isStepCountingAvailable() {
      let now = midnightOfToday
      
      pedometer.startPedometerUpdatesFromDate(now) {
        pedometerData, error in
        // Here is the start of the completion handler
        if let pedometerData = pedometerData {
          completionHandler(result: pedometerData.numberOfSteps.integerValue)
        }
        else if let error = error {
          let errMsg = self.handleMotionError(error)
          fatalError(errMsg)   //-- If all proper availability checking is done, we shouldn't never get here
        }
      }
    }
    else {
      updatesAvailable = false
    }
    
    return updatesAvailable
  }
}