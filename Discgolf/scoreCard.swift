//
//  scoreCard.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/27/23.
//

import SwiftUI
import CoreData


struct Scorecard: View {
    @Environment(\.managedObjectContext) private var viewContext
    var player: Player
    var game: Game
    var body: some View {
        
        var playerScore: [Score] {
            player.scores?.allObjects as? [Score] ?? []
        }
    
        VStack {
            HStack {
                Text("\(player.name ?? "")")
                    .font(.system(size: 37, weight: .medium))
                Spacer()
                Text("-1")
                    .font(.system(size: 37, weight: .medium))
            }
            .padding(.bottom, 10)
            HStack {
                ForEach(playerScore, id:\.self) { player in
                    VStack {
//                            ScoreCount(player: player, game: game, hole: hole)
                        Text("Hole:\(player.hole)")
                            .foregroundColor(SecondaryContent)
                            .font(.system(size: 12, weight: .bold))
                        Text("Score:\(player.score)")

                    }
                }
            }
        }
        .padding(.bottom, 16)
    }
}


struct ScoreCount: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Score.game, ascending: true)],
        animation: .default)
    private var Scores: FetchedResults<Score>
    var player: Player
    var game: Game
    var hole: Int
    var body: some View {
        
        var playerScore: [Score] {
            player.scores?.allObjects as? [Score] ?? []
        }
       
            Menu {
                Button("Par", action: {addScore(hole: hole, score: 1, game: game, player: player)})
                Button("Birdie", action: {})
                Button("Bogey", action: {})
                Button("Double Bogey", action: {})
                Button("Triple Bogey", action: {})
                Button("Eagle", action: {})
                Button("Ace", action: {})
                Button("Delete", action: {deleteItems(offsets: IndexSet(integer: hole))})
            } label: {
              holeScore
//                let _ = print("Hole#\(hole) has score: \(playerScore)")
        }
    }
    
    private func addScore(hole: Int, score: Int, game: Game, player: Player) {
        withAnimation {
            let newScore = Score(context: viewContext)
            newScore.hole = Int16(hole)
            newScore.score = Int16(score)
            newScore.game = game
            newScore.player = player
            print("New score created")
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { Scores[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }


}

var holeScore: some View {
    // Empty
    Rectangle()
        .foregroundColor( .white)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Surface30, lineWidth: 1))
        .frame(height: 115)
}
