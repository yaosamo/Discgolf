//
//  ContentView.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/18/23.
//

import SwiftUI
import CoreData

extension UINavigationController: UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct GameView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var game: Game

    @State private var holePicked = 0
    
    var holesPicker: some View {
        Picker("Choose round", selection: $holePicked) {
            Text("Front 9").tag(0)
            Text("Back 9").tag(1)
        }
        .pickerStyle(.segmented)
        .padding([.top, .bottom], 10)
    }
    
    var backButton: some View {
        Button(action: {dismiss()}) {
            Image(systemName: "chevron.backward")
                .foregroundColor(PrimaryContent)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 48, height: 48, alignment: .center)
                .background(.regularMaterial)
                .cornerRadius(40)
        }
        .padding(.leading, 0)
    }
    
    var body: some View {        
        ZStack(alignment:.topLeading){
            ScrollView {
                VStack(alignment: .leading) {
                    Text("")
                        .padding(.bottom, 56)
                    Text("18 June, 9pm")
                        .font(.system(size: 37, weight: .medium))
                    Text("Orchard Park")
                        .font(.system(size: 16, weight: .medium))
                        .padding(.top, -20)
                    holesPicker
                    var gamePlayers: [Player] {
                        game.players?.allObjects as? [Player] ?? []
                    }
                    ForEach(gamePlayers, id: \.self) { player in
                        Scorecard(player: player, game: game)
                    }
                }
                .padding([.leading, .trailing], 24)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            backButton
                .padding(24)
        }
    }

}
