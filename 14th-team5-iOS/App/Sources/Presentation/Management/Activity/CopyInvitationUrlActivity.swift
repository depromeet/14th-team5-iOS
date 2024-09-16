//
//  CopyInvitationUrlActivity.swift
//  Core
//
//  Created by 김건우 on 12/13/23.
//

import Core
import UIKit

// TODO: - 코드 리팩토링하기

public class CopyInvitationUrlActivity: UIActivity {
    private enum Activity {
        static let activityTitle: String = "초대 링크 복사"
        static let activitySymbol: String = "doc.on.doc"
    }
    
    let url: URL
    
    @Injected var provider: ServiceProviderProtocol
    
    let bundleId: String = Bundle.main.bundleIdentifier!
    var typeName: String = String(describing: CopyInvitationUrlActivity.self)
    
    public init(_ url: URL) {
        self.url = url
    }
    
    public override class var activityCategory: UIActivity.Category {
        return UIActivity.Category.action
    }
    
    public override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("\(bundleId).\(typeName)")
    }
    
    public override var activityTitle: String? {
        return Activity.activityTitle
    }
    
    public override var activityImage: UIImage? {
        return UIImage(systemName: Activity.activitySymbol)
    }
    
    public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    public override func perform() {
        UIPasteboard.general.string = url.description
        provider.managementService.didTapCopUrlAction() // TODO: - 오타 수정
    }
    
}
