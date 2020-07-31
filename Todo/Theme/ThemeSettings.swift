//
//  ThemeSettings.swift
//  Todo
//
//  Created by Shabbir Saifee on 7/16/20.
//  Copyright © 2020 Shabbir Saifee. All rights reserved.
//

import SwiftUI
//MARK: - Theme clas

class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
    
}
