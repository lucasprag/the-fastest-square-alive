//
//  GameOverScene.swift
//  the-fastest-square-alive
//
//  Created by Lucas Oliveira on 1/29/16.
//  Copyright © 2016 Maglabs. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // change the background of the scene to be black
        backgroundColor = SKColor.blackColor()
        
        // create a label to see game over on the screen
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "Game Over"
        label.fontSize = 80
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        backToPlay()
    }
    
    func backToPlay() {
        
        // run a action or a sequence of actions
        runAction(
            // sequence of actions
            SKAction.sequence([
            // action block to run in order to presente the scene
                SKAction.runBlock() {
                    // transition effect that seems like doors closing
                    let reveal = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                    // the game scene to present
                    if let scene = GameScene(fileNamed: "GameScene") {
                        // to best fill the screen
                        scene.scaleMode = .AspectFill
                        // present the scene
                        self.view?.presentScene(scene, transition:reveal)
                    }
                }
            ])
        )
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}