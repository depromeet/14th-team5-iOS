//
//  FamilyWidgetView.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import SwiftUI

struct FamilyWidgetView: View {
    let entry: FamilyWidgetEntry
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("8자로 입력해요")
                .foregroundColor(.white)
                .padding(.bottom, 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color.red.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    FamilyWidgetView(entry: FamilyWidgetEntry(date: Date(), family: Family(profileImage: "heart.fill", message: "나는 너무 힘들어.")))
}
