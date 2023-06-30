//
//  playerslist.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/22/23.
//

import SwiftUI
import CoreData


class GameMaster: ObservableObject {
    @Published var whosInfortheGame = NSSet()
}

struct PlayerslistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @StateObject var gameMaster = GameMaster()
    @State private var showingPlayerList = false
    @State private var showingCreatePlayer = false
    @State private var selectedPlayers: [Player] = []
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    private var players: FetchedResults<Player>
    var games: FetchedResults<Game>
    
    var startGame: some View {
        Button("Let’s throw discs \(Image(systemName: "arrow.right"))") {
            //Create new game
            startNewGame()
            dismiss()
        }
        .padding([.top, .bottom], 25)
        .padding([.leading, .trailing], 32)
        .frame(maxWidth: .infinity)
        .font(Font.system(size: 32, weight: .medium))
        .background(.black)
        .foregroundColor(.white)
        .cornerRadius(4)
    }
    
    var addNewPlayer: some View {
        Button("\(Image(systemName: "plus"))") {
            showingCreatePlayer.toggle()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundColor(.black)
        .font(Font.system(size: 32, weight: .medium))
        .popover(isPresented: $showingCreatePlayer) {
            CreatePlayerView()
        }
    }
    
    var playerslistHeader: some View {
        HStack {
            Text("Who’s in for the game?")
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(PrimaryContent)
                    .font(.system(size: 20, weight: .medium))
                    .frame(width: 40, height: 40)
                    .background(Surface10)
                    .clipShape(Circle())
            }
        }
        .font(.system(size: 20, weight: .semibold))
        .listRowInsets(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
        .padding([.top, .bottom], 24)
    }
    
    var emptyState: some View {
        Text("No players make one")
            .font(.system(size: 32, weight: .regular))
            .listRowInsets(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
            .listRowSeparator(.hidden)
            .foregroundColor(SecondaryContent)
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            List {
                playerslistHeader
                if players.count > 0 {
                    ForEach(players, id:\.self) { player in
                        HStack{
                            Text("\(player.name ?? "")")
                            Spacer()
                            let playerIn = selectedPlayers.contains(player)
                            Button(playerIn ? "In" : "Out") {
                                withAnimation(.interpolatingSpring(stiffness: 1000, damping: 100)) {
                                    if playerIn {  selectedPlayers.removeAll(where: { $0 == player }) } else {selectedPlayers.append(player)}
                                }
                            }
                            .scaleEffect(playerIn ? 1 : 1.1, anchor: .center)
                            .frame(width: 70, height: 40)
                            .font(Font.system(size: 24, weight: .medium))
                            .foregroundColor(playerIn ? .white : PrimaryContent)
                            .background(playerIn ? InteractivePrimary : .white)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(playerIn ? InteractivePrimary : PrimaryContent, lineWidth: 2))
                            .cornerRadius(40)
                            .padding([.top, .bottom], 8)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    .font(.system(size: 32, weight: .regular))
                    .listRowInsets(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {emptyState}
                addNewPlayer
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            startGame
                .padding(32)
        }
    }
    
    private func startNewGame() {
        print("starting creating game")
        let hex = generateRandomHex()
        let RGB = hexToColor(hex: hex)
        let isDark = isColorTooDark(red: RGB.red, green: RGB.green, blue: RGB.blue)
        let newGame = Game(context: viewContext)
        
        newGame.timestamp = Date()
        newGame.location = "Game #\(games.count+1)"
        newGame.red = RGB.red
        newGame.blue = RGB.blue
        newGame.green = RGB.green
        newGame.isbglowcontrast = isDark
        print("selected players", selectedPlayers)
        newGame.players = NSSet(array: selectedPlayers)
        newGame.id = UUID()
        
        // create game
        // create new gameDay
        print("New Game created: \(newGame.location ?? "New game") \(selectedPlayers) are in!")
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { players[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                print("Game Deleted")
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
