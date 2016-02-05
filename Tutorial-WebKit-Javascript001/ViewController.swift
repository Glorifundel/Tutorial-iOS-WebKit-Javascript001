//
//  ViewController.swift
//  Tutorial-WebKit-Javascript001
//
//  Created by Kevin Quinn on 2/5/16.
//  Copyright © 2016 Kevin Quinn. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler{

    //--------------------------------------------------
    // MARK: Properties
    //--------------------------------------------------
    @IBOutlet var parentView: UIView! = nil
    
    var wkWebView: WKWebView?
    
    //  Example of listening in ios for a message fired from js
    //  in main.js:
    //              webkit.messageHandlers.jsEventHandler.postMessage("Hello from JavaScript");
    let jsMessageHandler = "jsEventHandler"
    //
    //  Example of calling a js function from ios
    let jsFunction = "redHeader()"
    
    //--------------------------------------------------
    // MARK: Functions
    //--------------------------------------------------
    
    override func loadView() {
        super.loadView()
        
        let wkContentController = WKUserContentController();
        let jsScript = WKUserScript(source: jsFunction, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
        
        wkContentController.addUserScript(jsScript)
        wkContentController.addScriptMessageHandler(self, name: jsMessageHandler)
        
        let wkConfiguration = WKWebViewConfiguration()
        wkConfiguration.userContentController = wkContentController
        
        self.wkWebView = WKWebView(frame: self.parentView.bounds, configuration: wkConfiguration)
        self.view = self.wkWebView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  load via url
        //let url = NSURL(string: "https://www.google.com")
        //
        //  load via url for http:// requires special App Transport Security permission in info.plist
        //let url = NSURL(string: "http://www.darknessdescending.com")
        //let request = NSURLRequest(URL: url!)
        //self.wkWebView!.loadRequest(request)
        
        //  load via file
        let fileUrl = NSBundle.mainBundle().pathForResource("index", ofType: "html")!
        let url = NSURL(fileURLWithPath: fileUrl)
        self.wkWebView!.loadFileURL(url, allowingReadAccessToURL: url)
    }
    
    //--------------------------------------------------
    // MARK: Protocols
    //--------------------------------------------------
    
    //WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if (message.name == jsMessageHandler) {
            print("ViewController.userContentController() - Javascript event has been received:\n\(message.body)")
        }
    }

}

