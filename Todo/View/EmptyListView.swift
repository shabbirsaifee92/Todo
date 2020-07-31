//
//  EmptyListView.swift
//  Todo
//
//  Created by Shabbir Saifee on 7/10/20.
//  Copyright © 2020 Shabbir Saifee. All rights reserved.
//

import SwiftUI

struct EmptyListView: View {
    //MARK: - properties
    @State private var isAnimated: Bool = false
    let illustrations: [String] = [
        "illustration-no1",
        "illustration-no2",
        "illustration-no3"
    ]
    
    let tips: [String] = [
        "Use your time wisely.",
        "Slow and steady wins the race.",
        "Keep it short and sweet.",
        "Put hard tasks first.",
        "Rewards yourself after work.",
        "Collect tasks ahead of time.",
        "Each night schedule for tomorrow"
    ]
    
    
    //MARK: - body
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image(illustrations.randomElement()!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                Text(tips.randomElement()!)
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
            }//:vstack
                .padding(.horizontal)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -50)
                .animation(Animation.easeOut(duration: 1.5))
                .onAppear() {
                    self.isAnimated.toggle()
            }
        }//:zstack
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("ColorBase"))
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .environment(\.colorScheme, .dark)
    }
}
