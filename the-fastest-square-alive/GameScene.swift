//
//  GameScene.swift
//  the-fastest-square-alive
//
//  Created by Lucas Oliveira on 1/28/16.
//  Copyright (c) 2016 Maglabs. All rights reserved.
//

import SpriteKit

enum Physics {
    static let Character: UInt32 = 0b1     // 1
    static let Floor    : UInt32 = 0b10    // 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // characters
    let floor = SKSpriteNode(imageNamed: "blue")
    let player = SKSpriteNode(imageNamed: "orage")
    var enemies = [SKSpriteNode]()
    
    // timers
    var lastTime = 0
    var currentTime = 0
    
    override func didMoveToView(view: SKView) {
        // tell the physics world that the class the implements
        // the SKPhysicsContactDelegate is the GameScene
        physicsWorld.contactDelegate = self
        
        setupFloor()
        setupPlayer()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 70.0))
    }
    
    override func update(delta: CFTimeInterval) {
        // loop all enemies and make then walk to collide with the plyer
        for enemy in enemies {
            enemy.position = CGPoint(x: Double(enemy.position.x) - 5, y: Double(enemy.position.y))
        }
        
        currentTime = Int(delta)
        
        if (lastTime == 0) {
            lastTime = currentTime
        }
        
        if (currentTime > (lastTime + 1)) {
            lastTime = currentTime
            spawEnemy()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("1. \(contact.bodyA.node!.name) and 2. \(contact.bodyB.node!.name)")
        
        if (contact.bodyA.node!.name == "player" && contact.bodyB.node!.name == "enemy") {
            gameOver()
        }
    }
    
    func gameOver() {
        // cleanup the scene
        player.removeFromParent()
        for enemy in enemies {
            enemy.removeFromParent()
        }
        // transition effect that seems like doors opening
        let reveal = SKTransition.doorsOpenHorizontalWithDuration(0.5)
        
        // create the scene
        let gameOverScene = GameOverScene(size: self.size)
        
        // present the game over scene with the transition
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    func setupPlayer() {
        // we define a name to our node
        player.name = "player"
        
        // in this case we want a fixed size
        player.size = CGSize(width: 50, height: 50)
        
        // we put it in the halt of screen - some space + halt of the player width
        player.position = CGPoint(x: CGRectGetMidX(self.frame) - 180 + 25, y: CGRectGetMidY(self.frame))
        
        // we create a physics body with the size of the player
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        
        // yes, it's that simple to be affected by gravity
        player.physicsBody?.affectedByGravity = true
        
        // make the player collide with the floor
        player.physicsBody?.categoryBitMask = Physics.Character
        player.physicsBody?.collisionBitMask = Physics.Character
        
        // notify when the player collides
        player.physicsBody?.contactTestBitMask = Physics.Character
        
        // this add the player to the scene in order to appear in the screen
        addChild(player)
    }
    
    func setupFloor() {
        // we define a name to our node
        floor.name = "floor"
        
        // the size is represented by the CGSize
        // note that we are getting the size (CGSize) from the scene
        // and it will fill 1/3 of the screen
        floor.size = CGSize(width: self.size.width * 3, height: self.size.height/3)
        
        // we are putting the floor in the base of our screen
        floor.position = CGPoint(x: CGRectGetMinX(self.frame) + (floor.size.width / 2),
            y: CGRectGetMinY(self.frame) + (floor.size.height/2))
        
        // we create a physics body with the size of the floor
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: floor.size)
        
        // the floor doesn't move, right? =)
        floor.physicsBody?.affectedByGravity = false
        
        // make the floor collide with the player
        floor.physicsBody?.categoryBitMask = Physics.Character
        floor.physicsBody?.collisionBitMask = Physics.Floor
        
        // notify then the floor collides
        floor.physicsBody?.collisionBitMask = Physics.Floor
        
        // this add the floor to the scene in order to appear in the screen
        addChild(floor)
    }
    
    func spawEnemy(){
        // create the sprite node the red square
        let enemy = SKSpriteNode(imageNamed: "red")
        
        // define a name to the node
        enemy.name = "enemy"
        
        // define a size equal of the player
        enemy.size = CGSize(width: 50, height: 50)
        
        // define the position to be outside of the screen
        enemy.position = CGPoint(x: CGRectGetMidX(self.frame) + 350, y: CGRectGetMidY(self.frame) - 20)
        
        // create a physics body with the size of the player
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        
        // affected by gravity as the player
        enemy.physicsBody?.affectedByGravity = true
        
        // make it collide with the floor and the player
        enemy.physicsBody?.categoryBitMask = Physics.Character
        enemy.physicsBody?.collisionBitMask = Physics.Character
        
        // notify when the enemy collides
        enemy.physicsBody?.contactTestBitMask = Physics.Character
        
        // add the enemy to the scene
        addChild(enemy)
        
        // store the enemy to use later
        enemies.append(enemy)
    }
}
