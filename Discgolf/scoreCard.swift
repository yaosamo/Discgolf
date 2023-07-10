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
            ForEach(1...7, id: \.self) { score in
                Button(scoreButtonTitle(for: score), action: {
                    addScore(player: player, Int16(hole), score: Int16(score))
                })
            }
            Button("Remove", action: {
                deleteScore(player: player, hole: Int16(hole))
            })
        } label: {
            if let scores = player.scores?.allObjects as? [Score] {
                let scoreObjectExist = scores.first(where: { $0.hole == hole && $0.game == game })
                if scoreObjectExist != nil {
                    switch scoreObjectExist?.score ?? 0 {
                    case 1: par
                    case 2: birdie
                    case 3: bogey
                    case 4: doublebogey
                    case 5: triplebogey
                    case 6: eagle
                    case 7: ace
                    default: emptyHole
                    }
                } else { emptyHole }
            }
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
        
        private func updateScore(scoreItem: Score, player: Player, holeNumber: Int16, score: Int16) {
            viewContext.performAndWait {
                scoreItem.player = player
                scoreItem.game = game
                scoreItem.hole = holeNumber
                scoreItem.score = score
                try? viewContext.save()
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

// Helper function to generate the button title
func scoreButtonTitle(for score: Int) -> String {
    switch score {
    case 1: return "Par"
    case 2: return "Birdie"
    case 3: return "Bogey"
    case 4: return "Double Bogey"
    case 5: return "Triple Bogey"
    case 6: return "Eagle"
    case 7: return "Ace"
    default: return ""
    }
}


var par: some View {
    Rectangle()
        .foregroundColor(ParBg)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(ParBg, lineWidth: 1))
        .frame(height: 115)
}


var birdie: some View {
    Rectangle()
        .foregroundColor(BirdieBg)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(BirdieBg, lineWidth: 1))
        .frame(height: 115)
}

var bogey: some View {
    Rectangle()
        .foregroundColor(BogeyBG)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(BogeyBG, lineWidth: 1))
        .frame(height: 115)
}

var doublebogey: some View {
    Rectangle()
        .foregroundColor(BogeyBG)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(BogeyBG, lineWidth: 1))
        .frame(height: 115)
}

var triplebogey: some View {
    Rectangle()
        .foregroundColor(BogeyBG)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(BogeyBG, lineWidth: 1))
        .frame(height: 115)
}

var eagle: some View {
    Rectangle()
        .foregroundColor(EagleBG)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(EagleBG, lineWidth: 1))
        .frame(height: 115)
}

var ace: some View {
    Rectangle()
        .foregroundColor(AceBG)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(AceBG, lineWidth: 1))
        .frame(height: 115)
}
    
var emptyHole: some View {
    Rectangle()
        .foregroundColor(.white)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Surface30, lineWidth: 1))
        .frame(height: 115)
}
