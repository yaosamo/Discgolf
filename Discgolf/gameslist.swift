//
//  gameslist.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/22/23.
//

import SwiftUI
import CoreData

struct itemHoles: View {
    var bgcolor : Color
    var isDark : Bool
    var body: some View {
        ZStack(alignment:.center){
            Circle()
                .fill(bgcolor)
                .frame(width: 40, height: 40)
            Text("18")
                .shadow(radius: 1.5)
                .foregroundColor(isDark ? .white : PrimaryContent)
                .font(Font.system(size: 20, weight: .medium))
        }
    }
}

struct listItem: View {
    var timestamp : Date
    var location : String
    var body: some View {
        VStack(alignment:.leading)
        {
            Text("\(location)")
                .foregroundColor(PrimaryContent)
                .font(Font.system(size: 20, weight: .medium))
                .padding(.bottom, -2)
            Text("\(timestamp, formatter: itemFormatter)")
                .foregroundColor(SecondaryContent)
                .font(Font.system(size: 20, weight: .regular))
        }
    }
}

struct GamesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingPlayersList = false
    @State var selectedGame: UUID?
    
    @FetchRequest(entity: Game.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Game.timestamp, ascending: true)]) private var games: FetchedResults<Game>
    
    
    var emptyState: some View {
        Text("No games in the past")
            .font(Font.system(size: 20, weight: .medium))
            .listRowInsets(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
            .listRowSeparator(.hidden)
            .foregroundColor(SecondaryContent)
    }
    
    var gradientBehindHeader: some View {
        LinearGradient(gradient: Gradient(stops: [
            .init(color: .white, location: 0.7),
            .init(color: .white.opacity(0.5), location: 0.9),
            .init(color: .white.opacity(0), location: 1),
        ]), startPoint: .top, endPoint: .bottom)
        .frame(height: 420)
        .ignoresSafeArea(.all)
    }
    
    var header: some View {
        Button(action: {
            showingPlayersList.toggle()
        }, label: {
            VStack(alignment: .leading, spacing: -40) {
                Text("Start ")
                Text("new\(Image(systemName: "arrow.right")) ")
                Text("game ")
            }
            .font(Font.system(size: 112, weight: .semibold))
            .foregroundColor(.black)
        })
        .popover(isPresented: $showingPlayersList) {
            PlayerslistView(games: games)
        }
    }
    
    var body: some View {
        let GamesTotalCount = games.count
        NavigationView {
            ZStack(alignment: .topLeading){
                List {
                    Spacer()
                        .padding(.top, 350)
                    if GamesTotalCount > 0 {
                        ForEach(games) { game in
                            ZStack(alignment: .trailing) {
                                NavigationLink(
                                    destination: GameView(game: game),
                                    tag: game.id ?? UUID(),
                                    selection: $selectedGame
                                ) {
                                    listItem(timestamp: game.timestamp ?? Date(), location: game.location ?? "Game")
                                }
                                .onChange(of: games.count) { new in
                                    if GamesTotalCount <= new {
                                        if let mostRecentGame = games.last {
                                            selectedGame = mostRecentGame.id
                                        }
                                    }
                                }
                                itemHoles(bgcolor: Color(red: game.red, green:game.green, blue: game.blue), isDark: game.isbglowcontrast)
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .listRowInsets(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
                        .listRowSeparator(.hidden)
                    } else {emptyState}
                }
                .listStyle(.plain)
                gradientBehindHeader
                header
                    .padding([.leading, .trailing],24)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { games[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, HH:mm a"
    return formatter
}()
