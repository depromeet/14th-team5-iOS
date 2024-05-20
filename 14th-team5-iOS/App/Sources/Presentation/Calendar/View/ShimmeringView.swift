//
//  CalendarPlaceholderCell.swift
//  App
//
//  Created by 김건우 on 5/20/24.
//

import SwiftUI

struct ShimmeringView: View {
    
    // MARK: - Body
    var body: some View {
        Color.gray.opacity(0.1)
            .shimmering()
    }
    
}

// MARK: - Preview
struct ShimmeringView_Previews: PreviewProvider  {
    static var previews: some View {
        ShimmeringView()
    }
}
