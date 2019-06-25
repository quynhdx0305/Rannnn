//
//  DrawTrails.swift
//  Prite Kit Rock Lee
//
//  Created by QuynhDo4 on 4/9/19.
//  Copyright © 2019 QuynhDo4. All rights reserved.
//

import SpriteKit

class DrawTrail {
//    var pos: CGPoint
    var spinnyNode: SKShapeNode?
    var rotateNodes:[SKShapeNode] = []
    var w: CGFloat
    var queueRemove: SKAction?
    
    init( atCenter pos: CGPoint, toWidth w: CGFloat) {
        self.w = w
        self.draw(atCenter: pos)
    }
    
    func draw(atCenter pos: CGPoint) {
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.25))) // pi in 1/4sec
//            spinnyNode.run(SKAction.scale(by: CGFloat(1.5), duration: 0.5))
            let queueRotate = SKAction.sequence( [SKAction.scale(by: CGFloat(0.5), duration: 0.5),
                                                  SKAction.scale(by: CGFloat(2), duration: 0.5)])
            spinnyNode.run(SKAction.repeatForever(queueRotate))
            
            queueRemove = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()])
        }
        setPositionNodes(atCenter: pos)
    }
    
    func setPositionNodes(atCenter pos: CGPoint) {
        for _ in 0...3 {
            let n = spinnyNode?.copy() as! SKShapeNode
            rotateNodes.append(n)
        }
        rotateNodes[0].position = CGPoint(x: pos.x - 150, y: pos.y)
        rotateNodes[1].position = CGPoint(x: pos.x + 150, y: pos.y)
        rotateNodes[2].position = CGPoint(x: pos.x , y: pos.y - 150)
        rotateNodes[3].position = CGPoint(x: pos.x , y: pos.y + 150)
    }
    
    func updatePosition(atCenter pos: CGPoint) {
        rotateNodes[0].position = CGPoint(x: pos.x - 150, y: pos.y)
        rotateNodes[1].position = CGPoint(x: pos.x + 150, y: pos.y)
        rotateNodes[2].position = CGPoint(x: pos.x , y: pos.y - 150)
        rotateNodes[3].position = CGPoint(x: pos.x , y: pos.y + 150)
    }
    
    func deletePosition(atCenter pos: CGPoint) {
        for rt in rotateNodes {
            rt.removeAllActions()
            rt.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.25)))
            rt.run(queueRemove!)
        }
        rotateNodes.removeAll()
    }
}
