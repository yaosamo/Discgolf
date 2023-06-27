//
//  ContentView.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/18/23.
//

import SwiftUI
import CoreData
import SpriteKit

var InteractivePrimary = Color(red: 0xFB / 255.0, green: 0x3D / 255.0, blue: 0x01 / 255.0)
var PrimaryContent = Color(red: 0x28 / 255.0, green: 0x28 / 255.0, blue: 0x28 / 255.0)
var SecondaryContent = Color(red: 0x7E / 255.0, green: 0x83 / 255.0, blue: 0x94 / 255.0)
var Surface10 = Color(red: 0xFA / 255.0, green: 0xFA / 255.0, blue: 0xFA / 255.0)
var Surface30 = Color(red: 0xB0 / 255.0, green: 0xB9 / 255.0, blue: 0xC1 / 255.0)

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Game.timestamp, ascending: true)],
        animation: .default)
    private var games: FetchedResults<Game>
    
    var body: some View {
        GamesListView(games: games)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Game(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
