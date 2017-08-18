//
//  ViewController.swift
//  PTJSInterceptor
//
//  Created by xiaopeng on 2017/8/18.
//  Copyright © 2017年 putao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load html
        webView.delegate = self
        let url = Bundle.main.url(forResource: "h5", withExtension: "html")
        if let _url = url {
            webView.loadRequest(URLRequest.init(url: _url))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Navtive ----> JS
    @IBAction func native_call_js(_ sender: Any) {
        let ret = webView.stringByEvaluatingJavaScript(from: "native_call_js('hellojs');")
        print(ret ?? "")
        alert(message: ret ?? "")
    }
    
    // JS ----> Navtive: 拦截请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url?.absoluteString
        if let _url = url {
            if _url.range(of: "putao://") != nil {
                print(_url)
                alert(message: _url)
                return false
            }
        }
        return true
    }
    
    func alert(message: String) -> Void {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler:nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

