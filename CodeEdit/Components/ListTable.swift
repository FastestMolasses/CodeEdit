//
//  ListTable.swift
//  CodeEdit
//
//  Created by Abe Malla on 8/26/23.
//

import SwiftUI

struct ListTableItem: Identifiable {
    let id = UUID()
    var name: String
}

struct ContentView: View {
    @State private var items = [ListTableItem]()
    @State private var showingModal = false
    @State private var selection: ListTableItem.ID?

    var body: some View {
        VStack {
            Table(items, selection: $selection) {
                TableColumn("Items", value: \.name)
            }
        }
        .paneToolbar {
            HStack(spacing: 2) {
                Button {
                    showingModal = true
                } label: {
                    Image(systemName: "plus")
                }

                Divider()
                    .frame(minHeight: 15)

                Button {
                    removeItem()
                } label: {
                    Image(systemName: "minus")
                }
                .disabled(selection == nil)
                .opacity(selection == nil ? 0.5 : 1)
            }
            Spacer()
        }
        .sheet(isPresented: $showingModal) {
            NewListTableItemView { text in
                items.append(ListTableItem(name: text))
                showingModal = false
            }
        }
        .cornerRadius(6)
    }

    private func removeItem() {
        guard let selectedId = selection else { return }
        items.removeAll(where: { $0.id == selectedId })
        selection = nil
    }
}

struct NewListTableItemView: View {
    @State private var text = ""
    var completion: (String) -> Void

    var body: some View {
        VStack {
            Text("Enter new item name")
            TextField("Name", text: $text)
                .textFieldStyle(.roundedBorder)
            Button("Add") {
                if !text.isEmpty {
                    completion(text)
                }
            }
        }
        .padding()
    }
}

struct ListTablePreview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DebugAreaTabViewModel())
    }
}
