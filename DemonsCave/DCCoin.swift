//
//  DCCoin.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit

class DCCoin : DCObject
{
    var frames = [SKTexture]();
    
    func initializeAnimation()
    {
        let atlas = SKTextureAtlas(named: "Star")
        let sorted = atlas.textureNames.sorted()
        
        
        for textureName in sorted
        {
            let texture = atlas.textureNamed(textureName)
            frames.append(texture)
        }
    }
    
    convenience init()
    {
        self.init(texture: SKTextureAtlas(named: "Star").textureNamed("star0"));
        
        self.position = CGPoint(x: -400, y: 0)
        
        let texture = self.texture;
        
        if ((texture) != nil)
        {
            self.physicsBody = SKPhysicsBody(rectangleOf:texture!.size())
            
            let coinBitmask : UInt32 = 0x03;
            
            self.physicsBody?.isDynamic = true
            self.physicsBody?.collisionBitMask = 0x04
            self.physicsBody?.contactTestBitMask = 0x01 | coinBitmask
            self.physicsBody?.categoryBitMask = coinBitmask
        }
        
        self.initializeAnimation();
        self.startAnimation();
        
        self.restartAction();
        
        self.zPosition = 2;
        
        
        
    }
    
    func respawnY() -> CGFloat
    {
        let randomBool = DCUtils.randomBool();
        
        if (randomBool)
        {
            return CGFloat(300) - CGFloat(arc4random() % 180)
        }
        else
        {
            return CGFloat(-120) - CGFloat(arc4random() % 180)
        }
    }
    
    func respawn()
    {
        if (self.isHidden)
        {
            self.isHidden = false
        }
        self.restartAction()
    }
    
    func restartAction()
    {
        let respawnY = self.respawnY();
        
        self.position = CGPoint(x: self.position.x, y: respawnY)
        
        let startPositionActionX = SKAction.moveBy(x: 1200, y: 0, duration: 0);
        let endPositionAction = SKAction.moveBy(x: -1200, y: 0, duration: 4);
        
        self.run(SKAction.sequence([startPositionActionX,endPositionAction]), completion: {
            
            self.respawn()
            
        });
    }
    
    func startAnimation()
    {
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.1);
        
        self.run(animationAction, completion: {
            self.startAnimation()
        })
    }
}
