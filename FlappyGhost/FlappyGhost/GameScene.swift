//
//  GameScene.swift
//  FlappyClone
//
//  Created by Kevin on 2015/12/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

import SpriteKit

struct PhysicsCatagory {
    
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
}


class GameScene: SKScene {
    
    var Ground = SKSpriteNode()
    var Ghost = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    
    override func didMoveToView(view: SKView) {
        
        // Set Ground Attribute
        
        Ground = SKSpriteNode(imageNamed: "Ground.png")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width/2 , y: 0 + Ground.frame.height/2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOfSize: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.dynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        
        // Set Ghost Attribute
        
        Ghost = SKSpriteNode(imageNamed: "Ghost.png")
        Ghost.size = CGSize(width: 60, height: 70)
        Ghost.position = CGPoint(x: self.frame.width/2 - Ghost.frame.width, y: self.frame.height/2)
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height/2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.dynamic = true
        
        Ghost.zPosition = 2
        
        self.addChild(Ghost)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            
            gameStarted = true
            
            Ghost.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock({
                () in
                
                self.createWalls()
            })
            
            let delay = SKAction.waitForDuration(2.0)
            let SpawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatActionForever(SpawnDelay)
            self.runAction(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes,removePipes])
            
            Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            
        }
            
        else {
            
            Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        }
        
        
    }
    
    func createWalls(){
        
        wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall.png")
        let btmWall = SKSpriteNode(imageNamed: "Wall.png")
        
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.height/2 + 350 )
        btmWall.position = CGPoint(x: self.frame.width, y: self.frame.height/2 - 350 )
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.dynamic = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOfSize: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.affectedByGravity = false
        btmWall.physicsBody?.dynamic = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.runAction(moveAndRemove)
        
        self.addChild(wallPair)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
