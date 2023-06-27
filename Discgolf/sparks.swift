//
//  sparks.swift
//  Discgolf
//
//  Created by Yaroslav Samoylov on 6/20/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct SparksTestView: View {
    
    var body: some View {
        SpriteView(scene: scene,  options: .allowsTransparency)
            .ignoresSafeArea()
    }
    
    var scene: SKScene {
        let scene = SnowScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }
}


class SnowScene: SKScene {

    let snowEmitterNode = SKEmitterNode(fileNamed: "Sparks.sks")

    override func didMove(to view: SKView) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particleSize = CGSize(width: 40, height: 40)
        snowEmitterNode.particleLifetime = 2
        snowEmitterNode.particleLifetimeRange = 0
        snowEmitterNode.emissionAngle = 0
        snowEmitterNode.particleBirthRate = 200
        snowEmitterNode.xAcceleration = 0
        snowEmitterNode.particlePositionRange = CGVector(dx: 0, dy: 0)
        snowEmitterNode.particlePosition = CGPoint(x: 200, y: 700)
        addChild(snowEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        snowEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
}
