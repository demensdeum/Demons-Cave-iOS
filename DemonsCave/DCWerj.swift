//
//  DCWerj.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit

class DCWerj : DCObject
{
    var frames = [SKTexture]();
    var gameSpeed : CGFloat = 1000.0;
    
    func initializeAnimation()
    {
        let atlas = SKTextureAtlas(named: "Werj")
        let sorted = atlas.textureNames.sorted()
        
        
        for textureName in sorted
        {
            let texture = atlas.textureNamed(textureName)
            frames.append(texture)
        }
    }
    
    convenience init()
    {
        self.init(texture: SKTextureAtlas(named: "Werj").textureNamed("werj0"));
        
        self.position = CGPoint(x: 80, y: 420)

        let texture = self.texture;
        
        if ((texture) != nil)
        {
            self.physicsBody = SKPhysicsBody(rectangleOf:texture!.size())
            
            let werjBitmask : UInt32 = 0x01;
            
            self.physicsBody?.isDynamic = true
            self.physicsBody?.collisionBitMask = 0x04
            self.physicsBody?.contactTestBitMask = werjBitmask | 0x02 | 0x03
            self.physicsBody?.categoryBitMask = werjBitmask
        }
        
        self.zPosition = 3
        
        self.initializeAnimation();
        self.startAnimation()
    }
    
    func startAnimation()
    {
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.1);
        
        self.run(animationAction, completion: {
            self.startAnimation()
        })
    }
    
    func durationToY(_ toY: CGFloat) -> TimeInterval
    {
        let duration = abs(self.position.y - toY) / self.gameSpeed
        
        return TimeInterval(duration)
    }
}
