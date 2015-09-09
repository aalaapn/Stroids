//
//  GameScene.swift
//  Stroids
//
//  Created by Aalaap Narasipura on 4/11/15.
//  Copyright (c) 2015 Aalaap Narasipura. All rights reserved.
//

import SpriteKit

import SpriteKit


struct Physics{
    static let asteroid: UInt32 = 1
    static let bullet: UInt32 = 2
    static let spaceShip: UInt32 = 3
    static let enemy: UInt32 = 4
    static let enemyBullet: UInt32 = 5
}




class GameScene: SKScene, SKPhysicsContactDelegate {
    var score = Int()
    var scoringLabel = UILabel()
    var spaceShip = SKSpriteNode(imageNamed: "Ship.png")
    var levelLabel = UILabel()
    var highScore = Int()
    var stroidTimer = NSTimer()
    var stroidTime2 = NSTimer()
    
    override func didMoveToView(view: SKView) {
        var HighScoreDefault = NSUserDefaults.standardUserDefaults()
        if (HighScoreDefault.valueForKey("highScore") != nil){
            highScore = HighScoreDefault.valueForKey("highScore") as! NSInteger
        }
        else{
            highScore = 0
        }
        
        /* Setup your scene here */
        physicsWorld.contactDelegate = self
        
        //Scene Setup
        self.backgroundColor = UIColor.darkGrayColor()
        self.scene?.size = CGSize(width: 640, height: 1136)
        self.addChild(SKEmitterNode(fileNamed: "SnowParticle"))

        //SpaceShip Setup
        spaceShip.size.height = 70
        spaceShip.size.width = 70
        spaceShip.position = CGPointMake(500, 270)
        spaceShip.physicsBody = SKPhysicsBody(rectangleOfSize: spaceShip.frame.size)
        spaceShip.physicsBody?.affectedByGravity = false
        
        //SpaceShip Physics body setup
        spaceShip.physicsBody?.categoryBitMask = Physics.spaceShip
        spaceShip.physicsBody?.contactTestBitMask = Physics.asteroid
        spaceShip.physicsBody?.collisionBitMask = Physics.asteroid
        spaceShip.physicsBody?.dynamic = false
        
        //timers
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("bulletCreator"), userInfo: nil, repeats: true)
        stroidTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("stroidCreator"), userInfo: nil, repeats: true)
        var enemyTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("enemyCreator"), userInfo: nil, repeats: true)

        //Level label
        levelLabel = UILabel(frame: CGRect(x: frame.size.width/4, y: 5, width: 150, height: 20))
        levelLabel.text = "Level 1"
        levelLabel.backgroundColor = UIColor.clearColor()
        levelLabel.textColor = UIColor.whiteColor()
        levelLabel.font = UIFont(name: "Courier" , size: 15)
        
        //Scoring Label Setup
        scoringLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        scoringLabel.text = "\(score)"
        scoringLabel.backgroundColor = UIColor.clearColor()
        scoringLabel.textColor = UIColor.whiteColor()
        scoringLabel.font = UIFont(name: "Courier" , size: 15)
        
        //Adding items to the view
        self.view?.addSubview(scoringLabel)
        self.view?.addSubview(levelLabel)
        self.addChild(spaceShip)
    }
    
    func enemyCreator(){
        if (score > 50){
        levelLabel.text = "Level 5"
        var enemy = SKSpriteNode(imageNamed: "enemy.png")
        enemy.size.height=60
        enemy.size.width=60
        var min = self.size.width/8
        var max = self.size.width - 20
        var creationPostition = UInt32(max-min)
        enemy.position = CGPointMake(CGFloat(arc4random_uniform(creationPostition)), self.size.height)
        enemy.zPosition = -10
        
        let action = SKAction.moveToY(-100, duration: 5.0)
        let actionX = SKAction.moveToX(spaceShip.position.x, duration: 3)
        
        enemy.runAction(SKAction.repeatActionForever(actionX))
        enemy.runAction(SKAction.repeatActionForever(action))
        enemy.runAction(SKAction.sequence([action, actionX]))
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = Physics.enemy
        enemy.physicsBody?.contactTestBitMask = Physics.spaceShip | Physics.bullet
        enemy.physicsBody?.collisionBitMask = Physics.spaceShip | Physics.bullet

        
        self.addChild(enemy)
        
        if (score > 100){
        levelLabel.text = "Level Ω"
        var enemyBullet = SKSpriteNode(imageNamed: "enemy.png")
        enemyBullet.size.width = 20
        enemyBullet.size.height = 50
        enemyBullet.zPosition = -5
        enemyBullet.position = CGPointMake(enemy.position.x, enemy.position.y)
        let actionB = SKAction.moveToY(-100, duration: 3.0)
        let actionDestroyB = SKAction.removeFromParent()
        enemyBullet.runAction((SKAction.sequence([actionB, actionDestroyB])))
        
        // bullet.runAction(SKAction.repeatActionForever(action))
        enemyBullet.physicsBody = SKPhysicsBody(rectangleOfSize: enemyBullet.size)
        
        //bitmask
        enemyBullet.physicsBody?.categoryBitMask = Physics.enemyBullet
        enemyBullet.physicsBody?.contactTestBitMask = Physics.spaceShip
        enemyBullet.physicsBody?.collisionBitMask = Physics.spaceShip
        enemyBullet.physicsBody?.affectedByGravity = false
        
        
        enemyBullet.physicsBody?.dynamic = true
        self.addChild(enemyBullet)
            }}
        
    }
    
    func bulletCreator(){
        //bullet setup
        var bullet = SKSpriteNode(imageNamed: "Ship.png")
        bullet.size.width = 20
        bullet.size.height = 50
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
        
        let action = SKAction.moveToY(-100, duration: 5.0)
        let actionX = SKAction.moveToX(spaceShip.position.x, duration: 3)
        
        asteroid.runAction(SKAction.repeatActionForever(actionX))
        asteroid.runAction(SKAction.repeatActionForever(action))
        asteroid.physicsBody = SKPhysicsBody(rectangleOfSize: asteroid.size)
        
        if (score > 10){
            levelLabel.text = "Level 2"
            action.duration = action.duration/1.5
        }
        if (score > 20){
            levelLabel.text = "Level 3"
            action.duration = action.duration/1.2
            asteroid.size.height=60
            asteroid.size.width=60
            
        }
        if (score > 30){
            levelLabel.text = "Level 4"
            action.duration = action.duration/1.2
            asteroid.size.height=80
            asteroid.size.width=80
        }
        
        
        
        let actionDestroy = SKAction.removeFromParent()
        asteroid.runAction((SKAction.sequence([action, actionDestroy, actionX])))
        
        //Bitmask
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
            if(body1.node != nil && body2.node != nil){
                collisionWithBullet(body1.node as! SKSpriteNode, Bullet: body2.node as! SKSpriteNode)
            }
        }
        
        else if(((body1.categoryBitMask == Physics.asteroid && body2.categoryBitMask == Physics.spaceShip)) || ((body1.categoryBitMask == Physics.spaceShip && body2.categoryBitMask == Physics.asteroid))){
             if(body1.node != nil && body2.node != nil){
            collisionWithShip(body1.node as! SKSpriteNode , Ship: body2.node as! SKSpriteNode)
            }
        }
        
        else if(((body1.categoryBitMask == Physics.enemy && body2.categoryBitMask == Physics.spaceShip)) || ((body1.categoryBitMask == Physics.spaceShip && body2.categoryBitMask == Physics.enemy))){
            if(body1.node != nil && body2.node != nil){
                collisionWithShip(body1.node as! SKSpriteNode , Ship: body2.node as! SKSpriteNode)
            }
        }
        
        
       else if(((body1.categoryBitMask == Physics.enemy && body2.categoryBitMask == Physics.bullet)) || ((body1.categoryBitMask == Physics.bullet && body2.categoryBitMask == Physics.enemy))){
            if(body1.node != nil && body2.node != nil){
                collisionWithBullet(body1.node as! SKSpriteNode, Bullet: body2.node as! SKSpriteNode)
            }
        }

        else if(((body1.categoryBitMask == Physics.enemyBullet && body2.categoryBitMask == Physics.spaceShip)) || ((body1.categoryBitMask == Physics.spaceShip && body2.categoryBitMask == Physics.enemyBullet))){
            if(body1.node != nil && body2.node != nil){
                collisionWithShip(body1.node as! SKSpriteNode , Ship: body2.node as! SKSpriteNode)
            }
        }

        
    }
    

    
    func collisionWithBullet(Stroid: SKSpriteNode, Bullet: SKSpriteNode){
        Stroid.removeFromParent()
        Bullet.removeFromParent()
        score = score + 1
        scoringLabel.text = "\(score)"
    }
    
    
    func collisionWithShip(Stroid: SKSpriteNode, Ship: SKSpriteNode){
        var ScoreDefault = NSUserDefaults.standardUserDefaults()
        ScoreDefault.setValue(score, forKey: "Hscore")
        ScoreDefault.synchronize()
        
        if (score > highScore){
            var HighScoreDefault = NSUserDefaults.standardUserDefaults()
            HighScoreDefault.setValue(score, forKey: "highScore")
        }
        
        Stroid.removeFromParent()
        Ship.removeFromParent()
        
        self.view?.presentScene(EndScene(), transition: SKTransition.crossFadeWithDuration(1))
        scoringLabel.hidden = true
        levelLabel.hidden = true
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}