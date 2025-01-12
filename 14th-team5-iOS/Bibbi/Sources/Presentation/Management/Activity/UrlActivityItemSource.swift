//
//  UrlActivityItemSource.swift
//  Core
//
//  Created by 김건우 on 12/14/23.
//

import LinkPresentation

// TODO: - 코드 리팩토링하기

public class UrlActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var url: URL
    
    public init(title: String, url: URL) {
        self.title = title
        self.url = url
        super.init()
    }
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return url
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let code = extractCodeFromURL("\(url)") else {
            return url
        }
        let title = """
        링크로 입장한 뒤 초대코드를 입력하세요.
        
        \(url)
        초대코드 : \(code)
        """
        return title
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }
    
    public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "text.bubble")!)
        metadata.originalURL = url
        return metadata
    }
    
    private func extractCodeFromURL(_ url: String) -> String? {
        guard let codeRange = url.range(of: "o/")?.upperBound else {
            return nil
        }
        
        let code = url[codeRange...]
        return String(code)
    }
}
