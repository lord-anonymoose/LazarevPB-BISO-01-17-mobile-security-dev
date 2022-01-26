//
//  ContentView.swift
//  Task6
//
//  Created by Philipp on 26.01.2022.
//

import SwiftUI

let dateFormatter = DateFormatter()

struct Note: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let text: String
    var date = Date()
    var dateText: String {
        dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
        return dateFormatter.string(from: date)
    }
}

struct ContentView : View {
    @State private var items: [Note] = fetchData()
    
    var body: some View {
        TabView {
            MyNotesView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    //Text("My notes")
                }
            
            NewNoteView()
                .tabItem {
                    Image(systemName: "pencil.circle")
                    //Text("New Note")
                }
         /*
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    //Text("Settings")
                }
        */
        }
    }
    
    /*
    struct SettingsView: View {
        var body: some View {
            Text("Settings")
                .font(.system(size: 30, weight: .bold, design: .rounded))
        }
    }
    */
}

// View для создания новых заметок
struct NewNoteView: View {
    @State private var items: [Note] = fetchData()
    @State private var noteName = ""
    @State private var noteText = "Text"
    var body: some View {
        Form {
            Section (header: Text("Note Name")) {
                TextField("Name", text: $noteName)
                                    .padding(5)
            }
            Section (header: Text("Note Text")) {
                TextEditor (text: $noteText)
                        .padding(.all)
            }
            Button(action: {
                addNote(noteName: noteName, noteText: noteText)
            }) {
                Text("Add New Note")
            }
        }
    }
    func addNote(noteName: String, noteText: String) {
        let id = items.reduce(0) { max($0, $1.id) } + 1
        items.insert(Note(id: id, name: noteName, text: noteText), at: 0)
        save(notes: items)
    }
}

// View для просмотра доступных заметок
struct MyNotesView: View {
    @State private var items = fetchData()
    @State private var itemToDelete: Note?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { (item) in
                    VStack {
                        NavigationLink(destination: noteView(itemName: item.name, itemText: item.text)) {
                            Text(item.name)
                                .font(.caption)
                        }
                    }
                }.onDelete { (indexSet) in
                    self.items.remove(atOffsets: indexSet)
                    save(notes: items)
                }
                .onTapGesture {
                        print("touched item \(items)")
                    }
            }
                .navigationBarTitle("My Notes", displayMode: .inline)
                .toolbar {
                    EditButton()
                }
        }
        .onAppear {
            items = fetchData()
        }
    }
}

struct noteView: View {
    @State var itemName: String
    @State var itemText: String
    var body: some View {
        NavigationView {
            VStack {
                Text(itemText)
                    .navigationBarTitle(itemName)
            }
        }
    }
}



func save(notes: [Note]) {
    guard let data = try? JSONEncoder().encode(notes) else { return }
    UserDefaults.standard.set(data, forKey: "notes")
}

func fetchData() -> [Note] {
    guard let data = UserDefaults.standard.data(forKey: "notes") else { return [] }
    if let json = try? JSONDecoder().decode([Note].self, from: data) {
        return json
    }
    return []
}

