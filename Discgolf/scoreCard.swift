//
//  scoreCard.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/27/23.
//

import SwiftUI
import CoreData

var bogeyElement = Color(red: 0x53 / 255.0, green: 0x20 / 255.0, blue: 0x6B / 255.0)
var parElement = Color(red: 0x2E / 255.0, green: 0x41 / 255.0, blue: 0x4F / 255.0)
var birdieElement = Color(red: 0x54 / 255.0, green: 0x66 / 255.0, blue: 0x0C / 255.0)
var eagleElement = Color(red: 0x12 / 255.0, green: 0x6D / 255.0, blue: 0x3C / 255.0)
var aceElement = Color(red: 0x1E / 255.0, green: 0x40 / 255.0, blue: 0x67 / 255.0)

struct Scorecard: View {
    @Environment(\.managedObjectContext) private var viewContext
    var player: Player
    var game: Game
    var scores: [Score]
    @State var score = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("\(player.name ?? "")")
                    .font(.system(size: 37, weight: .medium))
                Spacer()
                
                    // total score sum, need to apply appropriate -1 count
                    let totalScore = scores.reduce(0, { $0 + $1.score })
                
                    Text("\(totalScore)")
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
                    addScore(player: player, Int16(hole), score: Int16(score)) // add check for Update
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
    ZStack {
        Rectangle()
            .foregroundColor(ParBg)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(ParBg, lineWidth: 1))
            .frame(height: 115)
        VStack{
            Rectangle()
                .foregroundColor(parElement)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(parElement, lineWidth: 1))
                .frame(width: 15, height: 3)
            Rectangle()
                .foregroundColor(parElement)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(parElement, lineWidth: 1))
                .frame(width: 15, height: 3)
        }
    }
}


var birdie: some View {
    ZStack {
        Rectangle()
            .foregroundColor(BirdieBg)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(BirdieBg, lineWidth: 1))
            .frame(height: 115)
        Rectangle()
            .foregroundColor(birdieElement)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(birdieElement, lineWidth: 1))
            .frame(width: 3, height: 15)
    }
}

var bogey: some View {
    ZStack {
        Rectangle()
            .foregroundColor(BogeyBG)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(BogeyBG, lineWidth: 1))
            .frame(height: 115)
        Image(systemName: "arrowtriangle.down.fill")
            .font(.system(size: 16))
            .foregroundColor(bogeyElement)
        
    }
}

var doublebogey: some View {
    ZStack {
        Rectangle()
            .foregroundColor(BogeyBG)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(BogeyBG, lineWidth: 1))
            .frame(height: 115)
        VStack(spacing: 3) {
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 16))
                .foregroundColor(bogeyElement)
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 16))
                .foregroundColor(bogeyElement)
        }
    }
}

var triplebogey: some View {
    ZStack {
        Rectangle()
            .foregroundColor(BogeyBG)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(BogeyBG, lineWidth: 1))
            .frame(height: 115)
        VStack(spacing: 3){
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 16))
                .foregroundColor(bogeyElement)
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 16))
                .foregroundColor(bogeyElement)
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 16))
                .foregroundColor(bogeyElement)
        }
    }
}

var eagle: some View {
    ZStack {
        Rectangle()
            .foregroundColor(EagleBG)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(EagleBG, lineWidth: 1))
            .frame(height: 115)
        VStack(spacing: 8) {
            Rectangle()
                .foregroundColor(eagleElement)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(eagleElement, lineWidth: 1))
                .frame(width: 3, height: 15)
            Rectangle()
                .foregroundColor(eagleElement)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(eagleElement, lineWidth: 1))
                .frame(width: 3, height: 15)
        }
    }
}

var ace: some View {
    ZStack {
        Rectangle()
            .foregroundColor(AceBG)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(AceBG, lineWidth: 1))
            .frame(height: 115)
        Image(systemName: "sparkle")
            .font(.system(size: 24))
            .foregroundColor(aceElement)
    }
}

var emptyHole: some View {
    Rectangle()
        .foregroundColor(.white)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Surface30, lineWidth: 1))
        .frame(height: 115)
}
