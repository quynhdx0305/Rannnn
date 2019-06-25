//
//  GameScenePresenter.swift
//  SpriteKitDemo2
//
//  Created by QuynhDo4 on 4/16/19.
//  Copyright © 2019 QuynhDo4. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

let NUMBER_SPACE = 100

protocol GameScenePresenterProtocol {
    init( view : GameScenceProtocol )
    
    /// operator time with person play
    ///
    /// - Parameter num: number Person
    /// - Returns: number after operator
    func randomTime(numPerson num: Int) -> Int

    /// operator Number Node Q
    ///
    /// - Parameters:
    ///   - number: Int
    ///   - type: E_NumberNodeQ
    /// - Returns: new number after operator
    func getNumberNode(number: Int, type: OppNodeQType) -> Int
    
    /// Check 5 finger will auto play
    ///
    /// - Parameter num: number fingger
    func checkFiveNode(NumberNodes num: Int)
    
    func startRun(Random ran: Int, ArrUITouch arr: [UITouch])
}

//.............................................................. class Presenter Game Scence
class GameScenePresenter {
    var view: GameScenceProtocol
    required init(view: GameScenceProtocol) {
        self.view = view
        self.view.setupPresenter(presenter: self)
    }
    
}

//.............................................................. implement Presenter Protocol
extension GameScenePresenter: GameScenePresenterProtocol {
    func startRun(Random ran: Int, ArrUITouch arr: [UITouch]) {
        var _count = ran
        let _per = ran - NUMBER_SPACE
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (timer) in
            self.view.deleteAllNodeSpectial()
            _count -= 1
            let _ranPer = Int.random(in: 0..._per)
            self.view.createNodeSpecial(Touch: arr[_ranPer])
            
            if _count == 0 {    // end Timer
                timer.invalidate()
            }
            
        }
    }
    
    func checkFiveNode(NumberNodes num: Int) {
        if num == 5 {
            view.autoRun()
        } else if num < 5{
            view.waitRun()
        } else {
            print("GameScenePresenterProtocol number > 5")
        }
    }
    
    func getNumberNode(number: Int, type: OppNodeQType) -> Int {
        switch type {
        case OppNodeQType.ADD:
            return number + 1
        case OppNodeQType.SUB:
            return number - 1
        }
    }

    func randomTime( numPerson num: Int ) -> Int {
        return Int.random(in: 1...num) + NUMBER_SPACE
    }
}
