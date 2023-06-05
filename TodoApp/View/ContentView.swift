//
//  ContentView.swift
//  TodoApp
//
//  Created by M_2195552 on 2023-06-02.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showingSettingsView: Bool = false
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)],
        animation: .default)
    private var todos: FetchedResults<Todo>
    
    //MARK: - Functions
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todos[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unkown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        } //: HSTACK
                        .padding(.vertical, 10)
                    } //: ForEach
                    .onDelete(perform: deleteItems)
                } //: List
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.showingAddTodoView.toggle()
                        } label: {
                            Image(systemName: "plus")
                        } //: Button
                        .sheet(isPresented: $showingAddTodoView) {
                            AddTodoView()
                        }
                    }
                } //: toolbar
                
                // MARK: - No Todo Items
                if todos.count == 0 {
                  EmptyListView()
                }
            } //: ZStack
            .sheet(isPresented: $showingAddTodoView) {
              AddTodoView().environment(\.managedObjectContext, self.viewContext)
            }
            .overlay(
              ZStack {
                Group {
                  Circle()
                    //.fill(themes[self.theme.themeSettings].themeColor)
                    .opacity(self.animatingButton ? 0.2 : 0)
                    .scaleEffect(self.animatingButton ? 1 : 0)
                    .frame(width: 68, height: 68, alignment: .center)
                  Circle()
                    //.fill(themes[self.theme.themeSettings].themeColor)
                    .opacity(self.animatingButton ? 0.15 : 0)
                    .scaleEffect(self.animatingButton ? 1 : 0)
                    .frame(width: 88, height: 88, alignment: .center)
                }
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true) ,value: self.animatingButton)
                
                Button {
                  self.showingAddTodoView.toggle()
                } label: {
                  Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .background(Circle().fill(Color("ColorBase")))
                    .frame(width: 48, height: 48, alignment: .center)
                } //: BUTTON
                  //.accentColor(themes[self.theme.themeSettings].themeColor)
                  .onAppear {
                     self.animatingButton.toggle()
                  }
              } //: ZSTACK
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        } //: NavigationView
    }
}

//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
