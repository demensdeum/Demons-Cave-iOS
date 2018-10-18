//
//  DCIngameScene.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import SpriteKit

class DCInGameScene: DCScene, SKPhysicsContactDelegate, DCExplosionDelegate, DCGameScoreControllerDelegate
{
    var gameSpeed = SKSpriteNode().speed
    var maximalGameSpeed = CGFloat(6)
    
    var scoreLabel : SKLabelNode
    var caveBackgroundA : DCCaveBackground
    var caveBackgroundB : DCCaveBackground
    
    var pipeA : DCPipe
    var pipeB : DCPipe
    
    var coin : DCCoin
    
    var werj : DCWerj
    var enemy : DCEnemy
    
    var werjIsGoUp = true;
    var enemyIsGoUp = false;
    
    var speedBarEmpty : DCSpeedBarEmpty
    var speedBar : DCSpeedBar
    
    var boost = 0;
    
    var explosion : DCExplosion?
    
    override init()
    {
        self.maximalGameSpeed = self.gameSpeed * CGFloat(2)
        
        self.caveBackgroundA = DCCaveBackground()
        self.caveBackgroundB = DCCaveBackground()
        
        self.caveBackgroundA.position = CGPoint(x: -800, y: 0)
        self.caveBackgroundB.position = CGPoint(x: 0, y: 0)
        
        self.pipeA = DCPipe()
        self.pipeB = DCPipe()
        
        self.coin = DCCoin()
        
        self.werj = DCWerj()
        self.enemy = DCEnemy()
        
        self.speedBarEmpty = DCSpeedBarEmpty()
        self.speedBar = DCSpeedBar()
        
        self.scoreLabel = SKLabelNode.init(fontNamed:"ChelseaMarket-Regular")
        self.scoreLabel.horizontalAlignmentMode = .left
        self.scoreLabel.color = UIColor.white
        self.scoreLabel.position = CGPoint(x: 14, y: 440)
        self.scoreLabel.zPosition = 99;
        
        super.init(size: CGSize(width: 800, height: 480))
    }
    
    func drawScore()
    {
        self.scoreLabel.text = "Score: " + String(self.gameScoreController!.score)
    }
    
    func dcGameScoreControllerScoreAdded(_ dcGameScoreController: DCGameScoreController) {
        self.drawScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView)
    {
        self.startGame()
    }
    
    func startGame()
    {
        self.gameScoreController!.resetScore()
        self.gameScoreController!.dcGameScoreControllerDelegate = self
        self.drawScore()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.addChildToScene(caveBackgroundA)
        self.addChildToScene(caveBackgroundB)
        self.addChildToScene(werj)
        self.addChildToScene(enemy)
        
        self.addChildToScene(speedBarEmpty)
        self.addChild(speedBar.cropNode)
        
        self.addChild(self.scoreLabel)
            
        self.addChildToScene(self.pipeA)
            
        self.run(SKAction.wait(forDuration: 2), completion: {
                self.addChildToScene(self.pipeB)
            });
            
        self.run(SKAction.wait(forDuration: 1.15), completion: {
                self.addChildToScene(self.coin)
            });
        
    }
    
    func speedUp()
    {
        if (self.gameSpeed < maximalGameSpeed)
        {
            self.gameSpeed += 0.4
            self.pipeA.speed = self.gameSpeed
            self.pipeB.speed = self.gameSpeed
            self.coin.speed = self.gameSpeed
            
            self.soundController?.playSound(key: "speedUp")
        }
    }
    
    func incrementBoost()
    {
        self.boost += 1
        self.speedBar.setProgress(self.boost / 2)
        if (self.boost > 199)
        {
            self.boost = 0;
            self.speedUp()
        }
    }
    
    func moveWerjUpOrDown()
    {
        var action : SKAction = SKAction.moveTo(y: 10, duration: 1)
        
        if (self.werjIsGoUp)
        {
            action = SKAction.moveTo(y: 60, duration: self.werj.durationToY(60))
        }
        else
        {
            action = SKAction.moveTo(y: 420, duration: self.werj.durationToY(420))
        }
        
        self.werjIsGoUp = !self.werjIsGoUp
        
        werj.removeAction(forKey: "moveAction")
        werj.run(action, withKey: "moveAction")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.moveWerjUpOrDown()
    }
    
    func enemyGoDown()
    {
        let action = SKAction.moveTo(y: 0, duration: self.enemy.durationToY(0))
        
        self.enemy.run(action)
    }
    
    func enemyGoUp()
    {
        let action = SKAction.moveTo(y: 370, duration: self.enemy.durationToY(370))
        
        self.enemy.run(action)
    }
    
    func enemyAvoidCollisionWithPipe()
    {
        let pipes = [self.pipeA, self.pipeB]
        
        let sortedPipes = pipes.sorted{$0.position.x > $1.position.x}
        
        let nearPipe = sortedPipes[0];
        
        if (nearPipe.position.y > 120)
        {
            enemyGoDown()
        }
        else
        {
            enemyGoUp()
        }
        
    }
    
    func gameOver()
    {
        if (self.explosion == nil)
        {
            self.pipeA.removeAllActions()
            self.pipeB.removeAllActions()
            self.werj.removeAllActions()
            self.enemy.removeAllActions()
            self.caveBackgroundA.removeAllActions()
            self.caveBackgroundB.removeAllActions()
            self.coin.removeAllActions()
            
            self.werj.isHidden = true
            
            explosion = DCExplosion()
            explosion!.dcExplosionDelegate = self
            
            explosion!.position = self.werj.position
            
            self.addChild(explosion!)
        }
    }
    
    func gotCoin()
    {
        if (coin.isHidden == false)
        {
            self.gameScoreController?.addScore(100)
            self.coin.isHidden = true
            self.soundController?.playSound(key: "coin")
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == 0x03 || bodyB.categoryBitMask == 0x03)
        {
            self.gotCoin();
        }
        else
        {
            self.soundController?.playSound(key: "explosion")
            self.gameOver();
        }
    }
    
    func dcExplosionDidFinish(_ explosion: DCExplosion)
    {
        self.dcSceneDelegate!.dcSceneDidFinish(self)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        self.enemyAvoidCollisionWithPipe()
        self.incrementBoost()
        super.update(currentTime)
    }
}
