//
//  EndScene.swift
//  Stroids
//
//  Created by Aalaap Narasipura on 4/12/15.
//  Copyright (c) 2015 Aalaap Narasipura. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : SKScene{
    
    var restart : UIButton!
    var Highscore : Int!
    var titleLabel : UILabel!
    var highScoreLabel : UILabel!
    
    override func didMoveToView(view: SKView) {
        self.scene?.size = CGSize(width: 640, height: 1136)
        scene?.backgroundColor = UIColor.blackColor()
        self.addChild(SKEmitterNode(fileNamed: "MainScene"))
        
        //StartButton
        restart = UIButton(frame: CGRect(x: 0, y: view.frame.size.height/2, width: view.frame.size.width/2, height: 30))
        restart.center = CGPoint(x: view.frame.size.width/2 , y: view.frame.width/1.5)
        restart.setTitle("Start", forState: UIControlState.Normal)
        restart.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        restart.titleLabel!.font = UIFont(name: "Courier", size: 24)
        restart.addTarget(self, action: Selector("restartFunc"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(restart)
        
        //Title Label
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        titleLabel.center = CGPoint(x: frame.size.width/2.89, y: view.frame.width/7)
        titleLabel.text = "Stroids"
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "Courier" , size: 20)
        self.view?.addSubview(titleLabel)
        
        
        //HighscoreStuff
        var ScoreDefault = NSUserDefaults.standardUserDefaults()
        var Score = ScoreDefault.valueForKey("Hscore") as! NSInteger
        
        var HighscoreDefault = NSUserDefaults.standardUserDefaults()
        Highscore = HighscoreDefault.valueForKey("highScore") as! NSInteger
        
        //highscore label
        highScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        highScoreLabel.center = CGPoint(x: frame.size.width/3.1, y: view.frame.width)
        highScoreLabel.text = "Highscore: \(Highscore)"
        highScoreLabel.backgroundColor = UIColor.clearColor()
        highScoreLabel.textColor = UIColor.whiteColor()
        highScoreLabel.font = UIFont(name: "Courier" , size: 15)
        self.view?.addSubview(highScoreLabel)

        
    }
    
    func restartFunc(){
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(1.0))
        restart.removeFromSuperview()
        highScoreLabel.removeFromSuperview()
        titleLabel.removeFromSuperview()
    }
}