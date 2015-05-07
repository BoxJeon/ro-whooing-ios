//
//  RWAccountViewController.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import UIKit

class RWAccountViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        if RWAuthorizationManager.isLoggedIn() {
            self.setupAsLoggedIn()
        } else {
            RWRestApiManager.getToken({ (error, token) -> Void in
                if error == nil {
                    RWPreferences.token = token
                    self.setupAsNotLoggedIn()
                }
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setupAsNotLoggedIn", name: RWAuthorizationManager.NOTIFICATION_LOGOUT_SUCCESS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setupAsLoggedIn", name: RWAuthorizationManager.NOTIFICATION_LOGIN_SUCCESS, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setupAsNotLoggedIn", name: RWAuthorizationManager.NOTIFICATION_LOGIN_FAIL, object: nil)
        
    }
    
    func setupView() {
        self.webView.delegate = self
    }
    
    func setupAsLoggedIn() {
        self.welcomeLabel.text = "환영합니다."
        self.logoutButton.enabled = true
        self.webView.hidden = true
    }
    
    func setupAsNotLoggedIn() {
        self.webView.hidden = false
        if let token = RWPreferences.token {
            let (path, _) = RWApi.Authorize.getPathAndModel()
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "\(path)?token=\(token)")!))
        } else {
            // TODO: token을 가져오지 못한 경우.
        }
    }

    @IBAction func onLogoutButtonTapped(sender: UIButton) {
        self.logoutButton.enabled = false
        RWAuthorizationManager.logout()
    }
    
    // Mark: UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        if let queries = webView.request?.URL?.query?.componentsSeparatedByString("&") {
            for query in queries {
                let keyValue = query.componentsSeparatedByString("=")
                if keyValue.count >= 2 && keyValue[0] == "pin" {
                    RWPreferences.pin = keyValue[1]
                    RWAuthorizationManager.login()
                }
            }
        }
    }
}
