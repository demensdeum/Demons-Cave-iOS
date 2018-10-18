//
//  DCEnemy.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit

class DCEnemy : DCObject
{
    var frames = [SKTexture]();
    var gameSpeed : CGFloat = 1000.0;    
    
    func initializeAnimation()
    {
        let atlas = SKTextureAtlas(named: "Enemy")
        let sorted = atlas.textureNames.sorted()
        
        
        for textureName in sorted
        {
            let texture = atlas.textureNamed(textureName)
            frames.append(texture)
        }
    }
    
    convenience init()
    {

        let atlas = SKTextureAtlas(named: "Enemy")
        self.init(texture: atlas.textureNamed("enemy0"));
        
        self.anchorPoint = CGPoint(x:0, y:0);
        
        self.position = CGPoint(x: 420, y: 340)
        self.zPosition = 4;
        
        self.initializeAnimation();
        self.startAnimation();
        
        self.alpha = 0
        
        self.run(SKAction.wait(forDuration: 13), completion: {
            
            let fromAlpha = SKAction.fadeAlpha(to: 1, duration: 1)
            self.run(fromAlpha)
        });
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
