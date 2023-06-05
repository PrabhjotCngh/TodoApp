//
//  AddTodoView.swift
//  TodoApp
//
//  Created by M_2195552 on 2023-06-02.
//

import SwiftUI

struct AddTodoView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    let priorities = ["High", "Normal", "Low"]
    
    // Theme
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    //MARK: - Function
    private func addItem() {
        withAnimation {
            let todo = Todo(context: self.managedObjectContext)
            todo.name = self.name
            todo.priority = self.priority

            do {
                try managedObjectContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    //MARK: - Todo name
                    TextField("Todo", text: $name)
                        .padding()
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    //MARK: - Todo Priority
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    } //: Picker
                    .pickerStyle(.segmented)
                    
                    //MARK: - Save Button
                    Button {
                        if self.name != "" {
                            addItem()
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Make sure to enter something for\nthe new todo item."
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    } //: Button
                } //: VStack
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                Spacer()
                
            } //: VStack
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    } //: Button
                }
            } //: toolbar
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(
                        Text("OK")
                    )
                )
            } //: alert
        } //: NavigationView
        .navigationViewStyle(.stack)
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}

//MARK: - Preview
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
