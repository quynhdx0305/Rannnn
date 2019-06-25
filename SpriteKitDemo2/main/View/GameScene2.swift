//
//  GameScene2.swift
//  SpriteKitDemo2
//
//  Created by QuynhDo4 on 4/12/19.
//  Copyright © 2019 QuynhDo4. All rights reserved.
//
import SpriteKit
import GameplayKit


extension GameScene {
    
    func createNodeTexture() {
        textureAtlas = SKTextureAtlas(named: "image")
        for i in 2...4 {
            let _name = "\(i).png"
            textureArray.append( SKTexture(imageNamed: _name) )
        }
        mainGuy = SKSpriteNode(imageNamed: textureAtlas.textureNames[0])
        //        mainGuy.size = CGSize(width: 100, height: 100)
        mainGuy.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        mainGuy.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.3)))
        self.addChild(mainGuy)
    }
    
    func createNodeCountDown() {
        self.label = self.childNode(withName: "lbCountDown") as? SKLabelNode
        if let label = self.label {
            label.position = CGPoint(x: size.width/2, y: size.height/2)
            label.fontSize = 100
            label.alpha = 0.0
            label.text = "5"
        }
    }
}
