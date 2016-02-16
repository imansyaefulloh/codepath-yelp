//
//  MenuViewController.swift
//  Yelp
//
//  Created by Tejen Hasmukh Patel on 2/15/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var browser: UIWebView!
    var businessId: String!;
    var webLoaded = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("http://m.yelp.com/menu/\(businessId)/main-menu");
        let url = NSURL(string: "http://m.yelp.com/menu/\(businessId)/main-menu");
        let nsr = NSURLRequest(URL: url!);
        browser.delegate = self;
        browser.loadRequest(nsr);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func menuUnavailable() {
        let pageTitle = browser.stringByEvaluatingJavaScriptFromString(
            "document.title"
        );  
        if(pageTitle == "Yelp - Error 404") {
            browser.hidden = true;
        }
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if(webLoaded == false) {
            webLoaded = true;
            menuUnavailable();
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
