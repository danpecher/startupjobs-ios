import WebKit
import SwiftUI

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
    @Binding var contentHeight: CGFloat
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var contentHeight: CGFloat
        var sizeObserver: NSKeyValueObservation?
        
        init(contentHeight: Binding<CGFloat>) {
            _contentHeight = contentHeight
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] result, error in
                self?.contentHeight = (result as? CGFloat ?? 0) + 20
            }
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(contentHeight: $contentHeight)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: Bundle.main.bundleURL)
    }
}
