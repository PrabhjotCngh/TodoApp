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
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    //MARK: - Todo name
                    TextField("Todo", text: $name)
                    
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
                            let todo = Todo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Make sure to enter something for\nthe new todo item."
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    } //: Button
                } //: Form
                
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
                } //: toolbar
            }
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(
                        Text("OK")
                    )
                )
            }
        } //: NavigationView
    }
}

//MARK: - Preview
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
