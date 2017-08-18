//
//  ViewController.swift
//  PTJSCore
//
//  Created by xiaopeng on 2017/8/18.
//  Copyright © 2017年 putao. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JavaScriptSwiftDelegate: JSExport {
    func js_call_native()
    
    //注意: JSExport不支持命名参数, 这里一定要加上 "_"
    func js_call_native_with_parameter(_ msg: String)
}

@objc class JSObjCModel: NSObject, JavaScriptSwiftDelegate {
    weak var jsContext: JSContext?
    weak var controller: UIViewController?

    func js_call_native() {
        print("bingo without parameter")
    }
    
    func js_call_native_with_parameter(_ msg: String) {
        DispatchQueue.main.async { () -> Void in
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.controller?.present(alert, animated: true, completion: nil)
        }
    }
}

class ViewController: UIViewController, UIWebViewDelegate {
   
    @IBOutlet weak var webView: UIWebView!
    var jsContext: JSContext!
    var model: JSObjCModel!

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
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //获得jsContext
        jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        //debug使用
        jsContext.exceptionHandler = { context, exception in
            if let ex = exception {
                print("JS exception: " + ex.toString())
            }
        }
        model = JSObjCModel()
        model.jsContext = jsContext
        model.controller = self
        
        // 这一步是将iOSModel这个模型注入到JS中
        // 在JS就可以通过iOSModel调用我们暴露的方法了
        self.jsContext.setObject(model, forKeyedSubscript:"iOSModel" as NSCopying & NSObjectProtocol)
    }
    
    // Navtive ----> JS
    @IBAction func native_call_js(_ sender: Any) {
        let js_func = self.jsContext.objectForKeyedSubscript("js_func")
        let ret = js_func?.call(withArguments: ["native message"])
        print(ret ?? "")
    }
}

