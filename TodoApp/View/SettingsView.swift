//
//  SettingsView.swift
//  TodoApp
//
//  Created by M_2195552 on 2023-06-05.
//

import SwiftUI

struct SettingsView: View {
    //MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconNames
    
    // Theme
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    @State private var isThemeChanged: Bool = false
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                // MARK: - FORM
                
                Form {
                    // MARK: - SECTION 1
                    Section(header: Text("Choose the app icon")) {
                        Picker(selection: $iconSettings.currentIndex, label:
                                HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(.primary, lineWidth: 2)
                                
                                Image(systemName: "paintbrush")
                                    .font(.system(size: 28, weight: .regular, design: .default))
                                    .foregroundColor(.primary)
                            } //: ZStack
                            .frame(width: 44, height: 44)
                            
                            Text("App Icons".uppercased())
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        } //: LABEL
                        ) {
                            ForEach(0..<iconSettings.iconNames.count) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer().frame(width: 8)
                                    
                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                } //: HStack
                                .padding(3)
                            }
                        } //: Picker
                        .onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Success! You have changed the app icon.")
                                    }
                                }
                            }
                        }
                    } //: SECTION 1
                    .padding(.vertical, 3)
                    
                    // MARK: - SECTION 2
                    Section(header:
                      HStack {
                        Text("Choose the app theme")
                        Image(systemName: "circle.fill")
                          .resizable()
                          .frame(width: 10, height: 10)
                          .foregroundColor(themes[self.theme.themeSettings].themeColor)
                      } //: HStack
                    ) {
                      List {
                        ForEach(themes, id: \.id) { item in
                          Button {
                            self.theme.themeSettings = item.id
                            UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                            self.isThemeChanged.toggle()
                          } label: {
                            HStack {
                              Image(systemName: "circle.fill")
                                .foregroundColor(item.themeColor)
                              
                              Text(item.themeName)
                            }
                          } //: Button
                        } //: Loop
                      } //: List
                    } //: SECTION 2
                      .padding(.vertical, 3)
                      .alert(isPresented: $isThemeChanged) {
                        Alert(
                          title: Text("SUCCESS!"),
                          message: Text("App has been changed to the \(themes[self.theme.themeSettings].themeName)!"),
                          dismissButton: .default(Text("OK"))
                        )
                    } //: alert
                    
                    // MARK: - SECTION 3
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "https://developer.apple.com/tutorials/swiftui")
                        FormRowLinkView(icon: "link", color: Color.blue, text: "Linkedin", link: "https://www.linkdin.com/in/prabhjot-singh-96654b9a")
                        FormRowLinkView(icon: "play.rectangle", color: Color.green, text: "Github", link: "https://github.com/PrabhjotCngh")
                    } //: SECTION 3
                    .padding(.vertical, 3)
                    
                    // MARK: - SECTION 4
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "John / Jane")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Gene")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.5.0")
                    } //: SECTION 4
                    .padding(.vertical, 3)
                } //: Form
                .listStyle(.grouped)
                .environment(\.horizontalSizeClass, .regular)
                
                // MARK: - FOOTER
                
                Text("Copyright © All rights reserved.\nBetter Apps ♡ Less Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
            } //: VStack
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    } //: Button
                }
            } //: toolbar
        } //: NavigationView
        .navigationViewStyle(.stack)
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}

//MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconNames())
    }
}
