//
//  ContentView.swift
//  Todo
//
//  Created by Shabbir Saifee on 7/10/20.
//  Copyright © 2020 Shabbir Saifee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Properties
    @State private var showingAddToDoView: Bool = false
    @State private var showingButtonAnimation: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @EnvironmentObject var iconSettings: IconNames
    
    // Theme
    @ObservedObject var theme = ThemeSettings()
    var themes: [Theme] = themeData
    
    //MARK: - body
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknwon")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                            )
                        }//:Hstack
                            .padding(.vertical, 10)
                    }//:foreach
                        .onDelete(perform: deleteTodo)
                }//:list
                    .navigationBarTitle("Todo", displayMode: .inline)
                    .navigationBarItems(
                        leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                        trailing:
                        Button(action: {
                            self.showingSettingsView.toggle()
                        }) {
                            Image(systemName: "paintbrush")
                        }
                        .accentColor(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView().environmentObject(self.iconSettings)
                        }
                )
                
                //MARK: - no todo items
                
                if todos.count == 0 { 
                    EmptyListView()
                }
                
            }//:zstack
                .sheet(isPresented: $showingAddToDoView) {
                    AddToDoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.showingButtonAnimation ? 0.15 : 0)
                            .scaleEffect(self.showingButtonAnimation ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.showingButtonAnimation ? 0.2 : 0)
                            .scaleEffect(self.showingButtonAnimation ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        
                    }
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    
                    Button(action: {
                        self.showingAddToDoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }//:button
                        .accentColor(themes[self.theme.themeSettings].themeColor)
                        .onAppear() {
                            self.showingButtonAnimation.toggle()
                    }
                    
                }//:zstack
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                , alignment: .bottomTrailing
            )
        }//:navigation
        
    }
    
    //MARK: - functions
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
