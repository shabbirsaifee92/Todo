//
//  SettingsView.swift
//  Todo
//
//  Created by Shabbir Saifee on 7/10/20.
//  Copyright © 2020 Shabbir Saifee. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    //MARK: - properties
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconNames
    
    //Theme
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    //MARK: - body
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                //MARK: - form
                Form {
                    //MARK: - section 1
                    Section(header: Text("Choose the app icon")) {
                        Picker(selection: $iconSettings.currentIndex, label:
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                                        .strokeBorder(Color.primary, lineWidth: 2)
                                    
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 28, weight: .regular, design: .default))
                                        .foregroundColor(.primary)
                                }
                                .frame(width:44, height:44)
                                Text("App Icons".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                                
                            }//:Label
                            
                        ) {
                            ForEach(0 ..< iconSettings.iconNames.count) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(9)
                                    
                                    Spacer().frame(width: 8)
                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }//:HStack
                                    .padding(3)
                            }
                        }//:picker
                            .onReceive([self.iconSettings.currentIndex].publisher.first()) { value in
                                let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName ) ?? 0
                                if index != value {
                                    UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        } else {
                                            print("Success")
                                        }
                                    }
                                }
                        }
                    }//: section 1
                        .padding(.vertical, 3)
                    
                    //MARK: - Section 2
                    Section(header:
                        HStack {
                            Text("Choose the app theme")
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(themes[self.theme.themeSettings].themeColor)
                        }
                        
                    ) {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button(action: {
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                }) {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        Text(item.themeName)
                                    }
                                }// :theme button
                                    .accentColor(.primary)
                                
                            }
                        }
                    }// :section 2
                        .padding(.vertical, 3)
                    
                    //MARK: - section 3
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: Color.blue, text: "Twitter", link: "https://twitter.com/shabbirsaifee92")
                        FormRowLinkView(icon: "play", color: Color.green, text: "Courses", link: "https://udemy.com")
                    }//:section3
                        .padding(.vertical, 3)
                    
                    //MARK: - section 4
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone/iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Shabbir")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Shabbir")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }//:section 4
                        .padding(.vertical, 3)
                    
                }//:form
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                //MARK: - footer
                Text("Copyright © All rights reserved\nBetter Apps ♡ Less Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
                
            }//:vstack
                .navigationBarItems(trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
            )
                .navigationBarTitle("Settings", displayMode: .inline)
                .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
        }//navigation
            .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconNames())
    }
}
