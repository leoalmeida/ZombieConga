//
//  GameScene.swift
//  ZombieConga
//
//  Created by Leonardo Almeida silva ferreira on 01/10/16.
//  Copyright © 2016 kkwFwk. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playableRect: CGRect
    let zombie = SKSpriteNode(imageNamed: "zombie1");
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPoint.zero
    var lastTouchLocation = CGPoint.zero
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0 // 1
        let playableHeight = size.width / maxAspectRatio // 2
        let playableMargin = (size.height-playableHeight)/2.0 // 3
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight) // 4
        super.init(size: size) // 5
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 6
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath.init()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width / 2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
        background.zPosition = -1
        
        addChild(background)
        
        zombie.position = CGPoint(x: 400, y: 400)
        
        addChild(zombie)
        
        debugDrawPlayableArea()
        
        // skView.showsFPS = false
        // skView.showsNodeCount = false
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0 }
        lastUpdateTime = currentTime
        print("\(dt*1000) milliseconds since last update")
        
        if (zombie.position - lastTouchLocation).length() <= zombieMovePointsPerSec * CGFloat(dt) {
            zombie.position = lastTouchLocation
            velocity = CGPoint.zero
        } else{
            moveSprite(sprite: zombie, velocity: velocity)
        }
        
        boundsCheckZombie()
        rotateSprite(sprite: zombie, direction: velocity)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        lastTouchLocation = touch.location(in: self)
    }
    
    func sceneTouched(touchLocation: CGPoint){
        moveZombieToward(location: touchLocation)
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        print("Amount to move: \(amountToMove)")
        sprite.position += amountToMove
        
    }
    
    func moveZombieToward(location: CGPoint) {
        
        let offset = location - zombie.position
        
        let direction = offset.normalized()
        
        velocity = direction * zombieMovePointsPerSec
        
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = direction.angle
    }
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0,
                                 y: playableRect.minY)
        let topRight = CGPoint(x: size.width,
                               y: playableRect.maxY)
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
}
