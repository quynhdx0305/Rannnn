//
//  GameScene.swift
//  Prite Kit Rock Lee
//
//  Created by QuynhDo4 on 4/2/19.
//  Copyright © 2019 QuynhDo4. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameScenceProtocol : class {
    func setupPresenter(presenter: GameScenePresenter)
    
    /// Create node __nodeQ__ but not show
    func createNode()
    /// addChild node __nodeQ__ and show
    func addNode(Touch t: UITouch)
    /// update location __nodeQ__
    func updateNode(Touch t: UITouch)
    /// delete node __nodeQ__
    func deleteNode(Touch t: UITouch)
    
    /// Run when have 5 finger person
    func autoRun()
    
    func waitRun()
    
    /// __Create__ node __Special__ and addChilden
    ///
    /// - Parameter t: 1 UITouch same 1 person
    func createNodeSpecial(Touch t: UITouch)
    /// __Update__ positon node __Special__
    func updateNodeSpecial(Touch t: UITouch)
    /// __Delete 1__ node __Special__
    func deleteNodeSpecial(Touch t: UITouch)
    /// __Delete All__ node __Special__
    func deleteAllNodeSpectial()
    
    /// __Create node Ring
    func createNodeScale(touch: UITouch)
    /// __Delete__ Node Ring
    func deleteNodeScale(touch: UITouch)
}


class GameScene: SKScene {
    
    var presenter : GameScenePresenterProtocol?
    /// Node when touch down
    ///
    /// name: nodeQ
    var node = SKSpriteNode(imageNamed: "1.png")
    var selectedNodes: [UITouch:SKSpriteNode] = [:]
    /// Count nodeQ did show
    var numPerson_: Int = 0
    var w: CGFloat = 0.0
    /// Node arround
    var arrNodeTrails: [UITouch:DrawTrail] = [:]
    
    /// array UITouch when finger person touch
    var arrUITouch_ = [UITouch]()

    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    var mainGuy = SKSpriteNode() // node demo
    
    /// List Node Ring
    var listNodeScale : [SKShapeNode] = []
    var label: SKLabelNode?
    
    
    //.............................................................................. Override did Move GameScene
    override func didMove(to view: SKView) {
        presenter = GameScenePresenter(view: self)
        
//        createNodeTexture()
        w = (self.size.width + self.size.height) * 0.01
        createNode()
//        createNodeCountDown()
//        label?.alpha = 0
//        createNodeScale()
        
    }
    
    
    //.............................................................................. Action
    func touchDown(atPoint pos : CGPoint, Touch t : UITouch) {
        
        if let _node = self.atPoint(pos) as? SKSpriteNode {     // `if` nodeQ did view
            if (_node.name == "nodeQ") {
                selectedNodes[t] = _node
            }
        }
        else {      // `else` nodeQ not view yet and new nodeQ
            arrUITouch_.append(t)
            numPerson_ = presenter!.getNumberNode(number: numPerson_, type: OppNodeQType.ADD)
            
            addNode(Touch: t)
        }
        
        presenter!.checkFiveNode(NumberNodes: numPerson_)
//        presenter!.randomTime(selectedNodes: selectedNodes)
    }
    
    func touchMoved(toPoint pos : CGPoint, Touch t : UITouch) {
        updateNode(Touch: t)
        updateNodeSpecial(Touch: t)
        //            arrNodeTrails[t]?.updatePosition(atCenter: pos)
        

        if let _inx = arrUITouch_.firstIndex(where: { $0 == t } ) {
            arrUITouch_[_inx] = t
        }
        
    }
    
    func touchUp(atPoint pos : CGPoint, Touch t : UITouch) {
        numPerson_ = presenter!.getNumberNode(number: numPerson_, type: OppNodeQType.SUB)
        deleteNode(Touch: t)
        
        //            arrNodeTrails[t]?.deletePosition(atCenter: pos)
        //            deleteNodeScale(touch: t)
        if let _node = self.atPoint(pos) as? SKSpriteNode {
            if (_node.name == "nodeQ") {
                let _inx = arrUITouch_.firstIndex(where: { $0.location(in: self) == pos } )
                arrUITouch_.remove(at: _inx!)
            }
        }
    }
    
    
    // ............................................................................. Overide Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(self.classForCoder, "... func touchesBegan ...")
        for t in touches { self.touchDown(atPoint: t.location(in: self),Touch: t.self) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self), Touch: t.self) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//            print(self.classForCoder, "... func touchesEnded ...")
        for t in touches { self.touchUp(atPoint: t.location(in: self), Touch: t.self) }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self), Touch: t.self) }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}


extension GameScene: GameScenceProtocol {

    func autoRun() {
        print(self.classForCoder, "...autoRun")
        let _ran = presenter!.randomTime(numPerson: numPerson_)
        
        presenter!.startRun(Random: _ran, ArrUITouch: arrUITouch_)
        
    }
    
    func waitRun() {
        print(self.classForCoder, "...waitRun")
    }
    
    //............ node Custom
    func createNodeSpecial(Touch t: UITouch) {
        
        arrNodeTrails[t] = DrawTrail(atCenter: t.location(in: self), toWidth: w)

        for rotateNode in arrNodeTrails[t]!.rotateNodes {
            addChild(rotateNode)
        }
    }
    
    func updateNodeSpecial(Touch t: UITouch) {
        let pos = t.location(in: self)
        arrNodeTrails[t]?.updatePosition(atCenter: pos)
    }
    
    func deleteNodeSpecial(Touch t: UITouch) {
        let _pos = t.location(in: self)
        arrNodeTrails[t]?.deletePosition(atCenter: _pos)
        print("arrrrrrrrrr delete", arrNodeTrails.count)
    }
    
    func deleteAllNodeSpectial() {
        arrNodeTrails.forEach { (nodeSpecial) in
            deleteNodeSpecial(Touch: nodeSpecial.key)
        }
        
        arrNodeTrails.removeAll()
        print("remove alllll", arrNodeTrails.count)
    }
    
    //.......... node Ring
    func createNodeScale(touch: UITouch) {
        let pos = touch.location(in: self)
        listNodeScale.append(SKShapeNode())
        listNodeScale.append(SKShapeNode())
        listNodeScale.append(SKShapeNode())
        
        //        listNodeScale[0] = SKShapeNode(circleOfRadius: 50)
        //        listNodeScale[0].position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        //        listNodeScale[0].fillColor = SKColor.orange
        
        //        listNodeScale[1] = SKShapeNode(circleOfRadius: 70)
        //        listNodeScale[1].position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        //        listNodeScale[1].strokeColor = SKColor.orange
        //        listNodeScale[1].lineWidth = 5.1
        
        listNodeScale[2] = SKShapeNode(circleOfRadius: 100)
        listNodeScale[2].position = CGPoint(x: pos.x, y: pos.y)
        listNodeScale[2].strokeColor = SKColor.blue
        listNodeScale[2].lineWidth = 10
        
        
        listNodeScale.forEach{ node in
            node.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.scale(to: 0.8, duration: 1),
                SKAction.scale(to: 1, duration: 1)])))
            self.addChild(node)
        }
    }
    
    func deleteNodeScale(touch: UITouch) {
        listNodeScale.forEach { (node) in
            node.removeAllActions()
            node.run(SKAction.removeFromParent())
        }
        listNodeScale.removeAll()
    }
    
    //.......... nodeQ
    func createNode() {
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.name = "nodeQ"
    }
    
    func addNode(Touch t: UITouch) {
        let _node = node.copy() as! SKSpriteNode
        _node.position = t.location(in: self)
        selectedNodes[t] = _node
        addChild(selectedNodes[t]!)
    }
    
    func updateNode(Touch t: UITouch) {
        let pos = t.location(in: self)
        if let _node = selectedNodes[t] {
            _node.position = pos
        }
    }
    
    func deleteNode(Touch t: UITouch) {

        if let _node = selectedNodes[t] {
            _node.removeFromParent()
        }
        selectedNodes[t] = nil
    }
    
    //.......... setup Presenter
    func setupPresenter(presenter: GameScenePresenter) {
        self.presenter = presenter
    }
}
