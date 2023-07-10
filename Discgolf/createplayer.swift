//
//  createplayer.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/20/23.
//

import SwiftUI
import CoreData

struct CreatePlayerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State var playername = "Player"
    
    var AddPlayerButton: some View {
        Button(action: {
                addPlayer()
            dismiss()
        }) {
            Text("Done")
                .padding([.top, .bottom], 25)
                .frame(maxWidth: .infinity)
                .font(Font.system(size: 32, weight: .medium))
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(4)
        }
        .contentShape(Rectangle())
    }
    
    var createPlayerHeader: some View {

        HStack {
            Text("Name")
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
    
    var body: some View {
        VStack(alignment: .leading) {
            createPlayerHeader
                .padding([.top], 24)
            TextField("Name", text: $playername)
                .font(.system(size: 80, weight: .semibold))
                .multilineTextAlignment(.leading)
                .padding(.top, -16)
            Spacer()
            AddPlayerButton
                .padding(.bottom, 32)
        }
        .padding([.leading, .trailing], 32)
    }

    private func addPlayer() {
        withAnimation {
            let newPlayer = Player(context: viewContext)
            newPlayer.name = playername
            try? viewContext.save()
            print("new player created")
        }
    }
    
    private func updatePlayer(player: Player) {
        withAnimation {
            viewContext.performAndWait {
                player.name = playername
                try? viewContext.save()
                print("player name updated")
            }
        }
    }

}
