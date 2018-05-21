//
//  GameScene.swift
//  ClownCar
//
//  Created by Elombe Kisala on 10/23/16.
//  Copyright © 2016 LiveLombs. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation


struct PhysicsCategory {
    static let Enemy1 :UInt32 = 0x1 << 0
    static let Enemy2 :UInt32 = 0x1 << 0
    static let Enemy3 :UInt32 = 0x1 << 0
    static let Enemy4 :UInt32 = 0x1 << 0
    static let DefendBall :UInt32 = 0x1 << 1
    static let MainBall :UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    var MainBall = SKSpriteNode(imageNamed: "car")
    
    var ZooBackground = SKSpriteNode(imageNamed: "road")
    
    var hits = 0
    
    var gameStarted = false
    
    var EnemyTimer = Timer()
    
    var TapToBeginLabel = SKLabelNode(fontNamed: "STHeitiJ-Medium")
    
    var ScoreLabel = SKLabelNode(fontNamed: "STHeitiJ-Medium")
    
    var HighscoreLabel = SKLabelNode(fontNamed: "STHeitiJ-Medium")
    
    var FadingAnimation = SKAction()
    
    var coinAudioURL = URL(fileURLWithPath: Bundle.main.path(forResource: "ClownCarChime", ofType: "wav")!)
    
    var carHitAudioURL = URL(fileURLWithPath: Bundle.main.path(forResource: "CarHiiit", ofType: "wav")!)
    
    var coinAudioPlayer = AVAudioPlayer()
    
    var carHitAudioPlayer = AVAudioPlayer()
    
    var Score = 0
    
    var Highscore = 0
    
    
    
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        
        coinAudioPlayer = try! AVAudioPlayer(contentsOf: coinAudioURL, fileTypeHint: nil)
        
        carHitAudioPlayer = try! AVAudioPlayer(contentsOf: carHitAudioURL, fileTypeHint: nil)
        
        let HighscoreDefault = UserDefaults.standard
        
        if HighscoreDefault.value(forKey: "Highscore") != nil {
            
            Highscore = HighscoreDefault.value(forKey: "Highscore") as! Int
            HighscoreLabel.text = "Highscore \(Highscore)"
            
        // Allow Background Music
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            
            
            
        }
        
        
        
        
        
        
        TapToBeginLabel.text = "Tap To Begin"
        TapToBeginLabel.fontSize = 35
        TapToBeginLabel.position = CGPoint(x: size.width * 0.5, y:size.height * 0.13)
        TapToBeginLabel.fontColor = UIColor.white
        TapToBeginLabel.zPosition = 2
        self.addChild(TapToBeginLabel)
        
        
        FadingAnimation = SKAction.sequence([SKAction.fadeIn(withDuration: 0.7), SKAction.fadeOut(withDuration: 0.7)])
        TapToBeginLabel.run(SKAction.repeatForever(FadingAnimation))
        
        HighscoreLabel.text = "Highscore : \(Highscore)"
        HighscoreLabel.position = CGPoint(x: size.width * 0.5, y:size.height * 0.85)
        HighscoreLabel.fontColor = UIColor.white
        HighscoreLabel.zPosition = 2
        self.addChild(HighscoreLabel)
        
        ScoreLabel.alpha = 0
        ScoreLabel.fontSize = 45
        ScoreLabel.position = CGPoint(x: size.width * 0.5, y:size.height * 0.85)
        ScoreLabel.fontColor = UIColor.white
        ScoreLabel.zPosition = 2
        ScoreLabel.text = "\(Score)"
        
        self.addChild(ScoreLabel)
        
        
        
        self.physicsWorld.contactDelegate = self
        
        
        ZooBackground.size = CGSize(width: frame.size.width, height: frame.size.height)
        ZooBackground.position = CGPoint(x: size.width * 0.5, y:size.height * 0.5)
        ZooBackground.zPosition = 0
        
        
        
        MainBall.size = CGSize(width: 225, height: 180)
        MainBall.position = CGPoint(x: size.width * 0.5, y:size.height * 0.5)
        MainBall.zPosition = 1
        MainBall.physicsBody = SKPhysicsBody(circleOfRadius: MainBall.size.width / 2)
        MainBall.physicsBody?.categoryBitMask = PhysicsCategory.MainBall
        MainBall.physicsBody?.collisionBitMask =  PhysicsCategory.Enemy1
        
        MainBall.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy1
        
        MainBall.physicsBody?.affectedByGravity = false
        MainBall.physicsBody?.isDynamic = false
        MainBall.name = "MainBall"
        
        
        
        self.addChild(MainBall)
        self.addChild(ZooBackground)
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node != nil && contact.bodyB.node != nil {
            
            let firstBody = contact.bodyA.node as! SKSpriteNode
            
            let fifthBody = contact.bodyB.node as! SKSpriteNode
            
            
            if ((firstBody.name == "Enemy1") && (fifthBody.name == "DefendBall")) {
                
                
                collisionDefendBall(firstBody, DefendBall: fifthBody)
       
                
            }
                
            else if ((firstBody.name == "DefendBall") && (fifthBody.name == "Enemy1")) {
                
                collisionDefendBall(fifthBody, DefendBall: firstBody)
                
                
            }
                
            else if ((firstBody.name == "MainBall") && (fifthBody.name == "Enemy1")) {
                
                collisionMainBall(fifthBody)
                
            }
                
            else if ((firstBody.name == "Enemy1") && (fifthBody.name == "MainBall")) {
                
                collisionMainBall(firstBody)
                
                
            }
            
        }
        
        
    }
    
    func collisionMainBall(_ Enemy1 : SKSpriteNode) {
        
        if hits < 3 {
            
            MainBall.run(SKAction.scale( by: 1.5, duration: 0.4))
            Enemy1.physicsBody?.affectedByGravity = true
            Enemy1.physicsBody?.isDynamic = true
            Enemy1.removeAllActions()
            
            MainBall.run(SKAction.sequence([SKAction.colorize(with: UIColor.magenta, colorBlendFactor: 1.0, duration: 0.2), SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 0.1)]))
            
            carHitAudioPlayer.play()
            
            hits += 1
            
            Enemy1.removeFromParent()
            
        }
        else {
            
            Enemy1.removeFromParent()
            EnemyTimer.invalidate()
            gameStarted = false
            
            ScoreLabel.run(SKAction.fadeOut(withDuration: 0.4))
            TapToBeginLabel.run(SKAction.fadeIn(withDuration: 0.2 ))
            TapToBeginLabel.run(SKAction.repeatForever(FadingAnimation))
            
            HighscoreLabel.run(SKAction.fadeIn(withDuration: 0.2))
            
            
            if Score > Highscore {
                
                let HighscoreDefault = UserDefaults.standard
                Highscore = Score
                HighscoreDefault.set(Highscore, forKey: "Highscore")
                
                HighscoreLabel.text = "Highscore: \(Highscore)"
                
            }
            
        }
        
    }
    
    
    func collisionDefendBall(_ Enemy1 : SKSpriteNode, DefendBall : SKSpriteNode) {
        
        Enemy1.physicsBody?.isDynamic = true
        Enemy1.physicsBody?.affectedByGravity = true
        Enemy1.physicsBody?.mass = 5.0
        DefendBall.physicsBody?.mass = 6.0
        
        
        Enemy1.physicsBody?.contactTestBitMask = 0
        Enemy1.physicsBody?.collisionBitMask = 0
        Enemy1.name = nil
        Enemy1.removeAllActions()
        DefendBall.removeAllActions()
        
        Score += 1
        ScoreLabel.text = "\(Score)"
        coinAudioPlayer.play()
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            
            EnemyTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(GameScene.Enemies), userInfo: nil, repeats: true)
            
            gameStarted = true
            MainBall.run(SKAction.scale(to: 0.44 , duration: 0.2))
            hits = 0
            
            
            
            
            TapToBeginLabel.removeAllActions()
            TapToBeginLabel.run(SKAction.fadeOut(withDuration: 0.2))
            HighscoreLabel.run(SKAction.fadeOut(withDuration: 0.2))
            
            ScoreLabel.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.fadeIn(withDuration: 1.0)]))
            
            
            Score = 0
            ScoreLabel.text = "\(Score)"
            
            
        }
            
        else {
            
            
            for touch in touches {
                let location = touch.location(in: self)
                
                let DefendBall = SKSpriteNode(imageNamed: "ball")
                
                DefendBall.position = MainBall.position
                DefendBall.size = CGSize(width: 30, height: 30)
                DefendBall.physicsBody =  SKPhysicsBody(circleOfRadius: DefendBall.size.width / 2)
                DefendBall.physicsBody?.affectedByGravity = false
                DefendBall.color = UIColor.white
                DefendBall.zPosition = 1
                
                DefendBall.physicsBody?.categoryBitMask = PhysicsCategory.DefendBall
                DefendBall.physicsBody?.collisionBitMask =  PhysicsCategory.Enemy1
                DefendBall.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy1
                
                
                DefendBall.name = "DefendBall"
                DefendBall.physicsBody?.isDynamic = true
                DefendBall.physicsBody?.affectedByGravity = true
                
                
                self.addChild(DefendBall)
                
                var dx = CGFloat(location.x - MainBall.position.x)
                var dy = CGFloat(location.y - MainBall.position.y)
                
                let magnitude = sqrt(dx * dx + dy * dy)
                
                dx /= magnitude
                dy /= magnitude
                
                let vector = CGVector(dx: 51.5 * dx, dy: 51.5 * dy)
                DefendBall.physicsBody?.applyImpulse(vector)
                
            }
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func Enemies() {
        
        
        let Enemy1 = SKSpriteNode(imageNamed: "clown")
        Enemy1.size = CGSize(width: 50, height: 50)
        Enemy1.zPosition = 2
        
        
        //Physics
        
        Enemy1.physicsBody = SKPhysicsBody(circleOfRadius: Enemy1.size.width / 2)
        Enemy1.physicsBody?.categoryBitMask = PhysicsCategory.Enemy1
        Enemy1.physicsBody?.contactTestBitMask = PhysicsCategory.DefendBall | PhysicsCategory.MainBall
        Enemy1.physicsBody?.collisionBitMask = PhysicsCategory.DefendBall | PhysicsCategory.MainBall
        Enemy1.physicsBody?.affectedByGravity = false
        Enemy1.physicsBody?.isDynamic = true
        Enemy1.name = "Enemy1"
        
        
        
        
        
        
        let RandomPosNumber = arc4random() % 4
        
        
        
        switch RandomPosNumber {
        case 0:
            
            Enemy1.position.x = 0
            
            
            let PositionY = arc4random_uniform(UInt32(frame.size.height ))
            
            Enemy1.position.y = CGFloat(PositionY)
            
            
            
            self.addChild(Enemy1)
            
            
            
            
            break
            
        case 1:
            
            Enemy1.position.y = 0
            
            let PositionX = arc4random_uniform(UInt32(frame.size.width))
            
            Enemy1.position.x = CGFloat(PositionX)
            
            
            
            self.addChild(Enemy1)
            
            
            
            
            break
            
        case 2:
            
            Enemy1.position.y = frame.size.height
            
            
            
            let PositionX = arc4random_uniform(UInt32(frame.size.width))
            
            Enemy1.position.x = CGFloat(PositionX)
            
            
            
            
            self.addChild(Enemy1)
            
            
            
            
            break
            
        case 3:
            
            Enemy1.position.x = frame.size.width
            
            
            
            let PositionY = arc4random_uniform(UInt32(frame.size.height ))
            
            Enemy1.position.y = CGFloat(PositionY)
            
            
            
            
            self.addChild(Enemy1)
            
            
            
            break
            
        default:
            break
        }
        
        
        Enemy1.run( SKAction.move(to: MainBall.position, duration: 1.09))
        
        
    }
    
    
    
}
