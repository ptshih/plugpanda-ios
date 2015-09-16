//
//  ViewController.swift
//  PlugPanda
//
//  Created by Peter Shih on 9/15/15.
//  Copyright (c) 2015 Peter Shih. All rights reserved.
//

import UIKit
import WebKit

// References
// http://www.priyaontech.com/2014/12/native-%E2%80%93-js-bridging-on-ios8-using-wkwebview/

class ViewController: UIViewController, WKNavigationDelegate {
  
  var webView: WKWebView?
  
  override func loadView() {
    super.loadView()
    
    // Listen to notification when app becomes active
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    

    // Create a subview for the webView that is below the status bar
    let frame = CGRectMake(0, 20, self.view.frame.width, self.view.frame.height - 20)
    self.webView = WKWebView(frame: frame)
    self.webView!.navigationDelegate = self;
    self.view.addSubview(self.webView!)
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Load the app URL
    let url = NSURL(string: "https://plugpanda.herokuapp.com")
    let req = NSURLRequest(URL: url!)
    self.webView!.loadRequest(req)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  // Handler for notification when app becomes active
  func onDidBecomeActive(notification: NSNotification) {
    // Reload webview if not already loading (such as during initial launch)
    if (!self.webView!.loading) {
      self.webView!.reload()
    }
    
//    let userDefaults = NSUserDefaults.init(suiteName: "group.com.petershih.PlugPanda")
//    print(userDefaults?.dictionaryRepresentation())
  }
  
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation) {
    // Retrieve accessToken from localStorage (set from webView)
    let jsString = "JSON.parse(localStorage.getItem('access_token') || '{}').val;"
    
    self.webView!.evaluateJavaScript(jsString, completionHandler: {(result, error) in
      print("Result: \(result), Error: \(error)");
      if ((error) != nil) {
        print("Javascript Error: \(error?.localizedDescription)")
        return;
      }
      
      let userDefaults = NSUserDefaults.init(suiteName: "group.com.petershih.PlugPanda")
      
      if ((result) != nil) {
        print("Saving accessToken: \(result)")
        userDefaults?.setObject(result, forKey: "accessToken")
      } else {
        print("Deleting accessToken")
        userDefaults?.removeObjectForKey("accessToken")
      }

      userDefaults?.synchronize()
    })
  }
  
}

