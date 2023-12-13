//
//  CopyInvitationUrlActivity.swift
//  Core
//
//  Created by 김건우 on 12/13/23.
//

import UIKit

public class CopyInvitationUrlActivity: UIActivity {
    enum Activity {
        static let activityTitle: String = "초대 링크 복사"
        static let activitySymbol: String = "doc.on.doc"
    }
    
    let provider: GlobalStateProviderType?
    
    let bundleId: String = Bundle.main.bundleIdentifier!
    var typeName: String = String(describing: CopyInvitationUrlActivity.self)
    
    public init(provider: GlobalStateProviderType?) {
        self.provider = provider
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
        provider?.activityGlobalState.didTapCopyInvitationUrlAction()
    }
    
}
