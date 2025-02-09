import SwiftUI

struct HTMLDescription: View {
    @Environment(\.self) var environment
    
    let content: String
    
    @State private var contentHeight: CGFloat = 0
    
    init(content: String) {
        self.content = content
    }
    
    var body: some View {
        HTMLStringView(htmlContent: wrappeContent(content), contentHeight: $contentHeight)
            .frame(maxWidth: .infinity)
            .frame(height: contentHeight)
            .padding(.top, 12)
    }
    
    private func wrappeContent(_ content: String) -> String {
        let foreground = Colors.foreground.resolve(in: environment)
        let links = Colors.primary.resolve(in: environment)

        return """
        <!DOCTYPE html>
        <html>

        <head>
            <meta name="viewport" content="initial-scale=1, user-scalable=no, width=device-width" />
            <style>
                @font-face {
                    font-family: 'Funnel';
                    src: url("FunnelDisplay-VariableFont_wght.ttf")  format('truetype');
                }
        
                body {
                    font-family: "Funnel";
                    font-size: 12pt;
                    margin: 0;
                    padding: 0;
                    color: rgb(\(foreground.red * 255), \(foreground.green * 255), \(foreground.blue * 255));
                    line-height: 17pt;
                }
        
                a {
                    color: rgb(\(links.red * 255), \(links.green * 255), \(links.blue * 255));
                }
        
                ul {
                    padding-left: 12pt;
                }
                
                img, video, iframe {
                    max-width: 100%;
                }
        
                video {
                    object-fit: fit;
                }
            </style>
        </head>

        <body>\(content)</body>

        </html> 
        """
    }
}

