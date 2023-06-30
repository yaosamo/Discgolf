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
 
        VStack {
            HStack {
                Text("\(player.name ?? "")")
                    .font(.system(size: 37, weight: .medium))
                Spacer()
                Text("E")
                    .font(.system(size: 37, weight: .medium))
            }
            .padding(.bottom, 10)
                HStack {
                    ForEach(1...9, id: \.self) { holeNumber in
                        VStack {
                            Holes(game: game, player: player, hole: holeNumber)
                            Text("\(holeNumber)")
                                .foregroundColor(SecondaryContent)
                                .font(.system(size: 12, weight: .bold))
                        }
                    }
                }
                
            
        }
        .padding(.bottom, 16)
    }
}


struct Holes: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var game: Game
    var player: Player
    var hole: Int
    var body: some View {
       
            Menu {
                Button("Par", action: {addScore(player: player, Int16(hole), score: 1)})
                Button("Birdie", action: {})
                Button("Bogey", action: {})
                Button("Double Bogey", action: {})
                Button("Triple Bogey", action: {})
                Button("Eagle", action: {})
                Button("Ace", action: {})
                Button("Remove", action: {deleteScore(player: player, hole: Int16(hole))})
            } label: {
                if let scores = player.scores?.allObjects as? [Score] {
                 let scoreExist = scores.first(where: { $0.hole == hole })
                    if scoreExist?.score != nil {
                        FullHole } else {EmptyHole}}
        }
    }

  
    private func addScore(player: Player, _ holeNumber: Int16, score: Int16) {
        let newScore = Score(context: viewContext)
        newScore.player = player
        newScore.game = game
        newScore.hole = holeNumber
        newScore.score = score
        
        do {
            try viewContext.save()
        } catch {
            // Handle the error
            print("Failed to save new score: \(error)")
        }
    }
    
    private func deleteScore(player: Player, hole: Int16) {
        if let scores = player.scores?.allObjects as? [Score] {
            let scoreToDelete = scores.first { $0.hole == hole }
            if let score = scoreToDelete {
                viewContext.delete(score)
                
                do {
                    try viewContext.save()
                } catch {
                    // Handle the error
                    print("Failed to delete score: \(error)")
                }
            }
        }
    }
    
}


// Hole styles
var EmptyHole: some View {
    // Empty
    Rectangle()
        .foregroundColor( .white)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Surface30, lineWidth: 1))
        .frame(height: 115)
}


var FullHole: some View {
    // Empty
    Rectangle()
        .foregroundColor( .green)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(.green, lineWidth: 1))
        .frame(height: 115)
}
