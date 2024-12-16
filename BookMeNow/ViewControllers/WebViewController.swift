//
//  WebViewController.swift
//  BookMeNow
//
//  Created by Neshwa on 15/02/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var url = ""
    var headerTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.header.text = self.headerTitle
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest(url: URL(string: url) ?? URL(fileURLWithPath: "")))
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
    
extension WebViewController : WKNavigationDelegate {
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
                
        }
            
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print(error.localizedDescription)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print(error.localizedDescription)
        }
            
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.shouldPerformDownload {
                decisionHandler(.download)
            }
            else {
                decisionHandler(.allow)
            }
        }
    }
        
    private func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationResponse.canShowMIMEType {
            decisionHandler(.download)
        }
        else {
            decisionHandler(.allow)
        }
    }
}

