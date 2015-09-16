//
//  ShareViewController.swift
//  PlugPandaLocation
//
//  Created by Peter Shih on 9/16/15.
//  Copyright © 2015 Peter Shih. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let userDefaults = NSUserDefaults.init(suiteName: "group.com.petershih.PlugPanda")
    let accessToken = userDefaults?.objectForKey("accessToken")
    print("accessToken: \(accessToken)")
  }

  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    if !contentText.isEmpty {
      return true
    }
    
    return false
  }

  override func didSelectPost() {
    print("Post -> \(self.contentText)")
    
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
  }

  override func configurationItems() -> [AnyObject]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }
  
}
