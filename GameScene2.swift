//
//  GameScene2.swift
//  Stroids
//
//  Created by Aalaap Narasipura on 4/11/15.
//  Copyright (c) 2015 Aalaap Narasipura. All rights reserved.
//

import SpriteKit

import SpriteKit


struct Physics2{
    static let asteroid: UInt32 = 1
    static let bullet: UInt32 = 2
    static let spaceShip: UInt32 = 3
}




class GameScene2: SKScene, SKPhysicsContactDelegate {
   
    var score = Int()
    var scoringLabel = UILabel()
    var spaceShip = SKSpriteNode(imageNamed: "vbam.png")
    //spaceShip.size.height = 30
    //spaceShip.size.width = 30
    override func didMoveToView(view: SKView) {
         print("in game scene 2")
        /* Setup your scene here */
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor .blackColor()
        
        self.addChild(SKEffectNode(fileNamed: "SnowParticle"))
        
        //SpaceShip
        spaceShip.size.height = 30
        spaceShip.size.width = 30
        spaceShip.position = CGPointMake(500, 270)
        spaceShip.physicsBody = SKPhysicsBody(rectangleOfSize: spaceShip.frame.size)
        spaceShip.physicsBody?.affectedByGravity = false
        
        //bitmasks
        spaceShip.physicsBody?.categoryBitMask = Physics.spaceShip
        spaceShip.physicsBody?.contactTestBitMask = Physics.asteroid
        spaceShip.physicsBody?.collisionBitMask = Physics.asteroid
        spaceShip.physicsBody?.dynamic = false
        
        //timers
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("bulletCreator"), userInfo: nil, repeats: true)
        var stroidTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("stroidCreator"), userInfo: nil, repeats: true)
        
        //Add to the SKScene
        
        scoringLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        scoringLabel.text = "\(score)"
        scoringLabel.backgroundColor = UIColor.clearColor()
        scoringLabel.textColor = UIColor.whiteColor()
        scoringLabel.font = UIFont(name: "Courier" , size: 15)
        self.view?.addSubview(scoringLabel)
        //self.addChild(spaceShip)
        
    }
    
    func bulletCreator(){
        var bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.size.width = 10
        bullet.size.height = 30
        bullet.zPosition = -5
        bullet.position = CGPointMake(spaceShip.position.x, spaceShip.position.y)
        let action = SKAction.moveToY(self.size.height+30, duration: 1.0)
        let actionDestroy = SKAction.removeFromParent()
        bullet.runAction((SKAction.sequence([action, actionDestroy])))
        
        // bullet.runAction(SKAction.repeatActionForever(action))
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        
        //bitmask
        bullet.physicsBody?.categoryBitMask = Physics.bullet
        bullet.physicsBody?.contactTestBitMask = Physics.asteroid
        bullet.physicsBody?.collisionBitMask = Physics.asteroid
        bullet.physicsBody?.affectedByGravity = false
        
        
        bullet.physicsBody?.dynamic = false
        self.addChild(bullet)
        
    }
    
    func stroidCreator(){
        var asteroid = SKSpriteNode(imageNamed: "Stroid.png")
        asteroid.size.height=40
        asteroid.size.width=40
        var min = self.size.width/8
        var max = self.size.width - 20
        var creationPostition = UInt32(max-min)
        asteroid.position = CGPointMake(CGFloat(arc4random_uniform(creationPostition)), self.size.height)
        
        let action = SKAction.moveToY(-100, duration: 2.0)
        let actionDestroy = SKAction.removeFromParent()
        asteroid.runAction((SKAction.sequence([action, actionDestroy])))
        asteroid.runAction(SKAction.repeatActionForever(action))
        asteroid.physicsBody = SKPhysicsBody(rectangleOfSize: asteroid.size)
        
        //Physicsbody Stuff
        asteroid.physicsBody?.categoryBitMask = Physics.asteroid
        asteroid.physicsBody?.contactTestBitMask = Physics.spaceShip | Physics.bullet
        asteroid.physicsBody?.collisionBitMask = Physics.bullet | Physics.spaceShip
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.dynamic = true
        
        self.addChild(asteroid)
        
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            spaceShip.position = location
            
        }
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var body1 : SKPhysicsBody = contact.bodyA
        var body2 : SKPhysicsBody = contact.bodyB
        
        
        if(((body1.categoryBitMask == Physics.asteroid && body2.categoryBitMask == Physics.bullet)) || ((body1.categoryBitMask == Physics.bullet && body2.categoryBitMask == Physics.asteroid))){
            
            collisionWithBullet(body1.node as! SKSpriteNode, Bullet: body2.node as! SKSpriteNode)
        }
            
        else if(((body1.categoryBitMask == Physics.asteroid && body2.categoryBitMask == Physics.spaceShip)) || ((body1.categoryBitMask == Physics.spaceShip && body2.categoryBitMask == Physics.asteroid))){
            
            collisionWithShip(body1.node as! SKSpriteNode , Ship: body2.node as! SKSpriteNode)
        }
    }
    
    
    
    func collisionWithBullet(Stroid: SKSpriteNode, Bullet: SKSpriteNode){
        Stroid.removeFromParent()
        Bullet.removeFromParent()
        score = score + 1
        scoringLabel.text = "\(score)"
    }
    
    
    func collisionWithShip(Stroid: SKSpriteNode, Ship: SKSpriteNode){
        //var ScoreDefault = NSUserDefaults.standardUserDefaults()
        //ScoreDefault.setValue(score, forKey: "score")
        //ScoreDefault.synchronize()
        
        //Stroid.removeFromParent()
        //Ship.removeFromParent()
        self.view?.presentScene(EndScene())
        scoringLabel.hidden = true
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}