//
//  UrlActivityItemSource.swift
//  Core
//
//  Created by 김건우 on 12/14/23.
//

import LinkPresentation

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
        return url
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

}
