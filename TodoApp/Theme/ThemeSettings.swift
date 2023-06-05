//
//  ThemeSettings.swift
//  TodoApp
//
//  Created by M_2195552 on 2023-06-05.
//

import SwiftUI

// MARK: - Theme Class
final public class ThemeSettings: ObservableObject {
  @Published public var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
    didSet {
      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
    }
  }
  
  private init() {}
  public static let shared = ThemeSettings()
}

// OLD CODE
//
//class ThemeSettings: ObservableObject {
//  @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
//    didSet {
//      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
//    }
//  }
//}
