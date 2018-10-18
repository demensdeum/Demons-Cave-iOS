//
//  DCPipe.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit

class DCPipe : DCObject
{
    convenience init()
    {
        self.init(imageNamed: "pipe");

        let texture = self.texture;
        
        if ((texture) != nil)
        {
            self.physicsBody = SKPhysicsBody.init(texture:texture!, size:texture!.size())
        }
        
        let pipeBitmask : UInt32 = 0x02;
        
        self.position = CGPoint(x: -400, y: 240)
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.collisionBitMask = pipeBitmask | 0x01
        self.physicsBody?.contactTestBitMask = pipeBitmask | 0x01
        self.physicsBody?.categoryBitMask = pipeBitmask
        
        
        self.restartAction();
        
        self.zPosition = 1;
    }
    
    func respawnY() -> CGFloat
    {
        let randomBool = DCUtils.randomBool();
        
        if (randomBool)
        {
            return CGFloat(300) - CGFloat(arc4random() % 180) + 240
        }
        else
        {
            return CGFloat(-120) - CGFloat(arc4random() % 180) + 240
        }
    }
    
    func scoreUp()
    {
        self.gameScoreController?.addScore(1)
    }
    
    func restartAction()
    {
        let respawnY = self.respawnY();
        
        self.position = CGPoint(x: self.position.x, y: respawnY)
        
        let startPositionActionX = SKAction.moveBy(x: 1300, y: 0, duration: 0);
        let endPositionAction = SKAction.moveBy(x: -1300, y: 0, duration: 4);
        
        self.run(SKAction.sequence([startPositionActionX,endPositionAction]), completion: {
            
            self.scoreUp();
            self.restartAction();
            
        });
    }
}
