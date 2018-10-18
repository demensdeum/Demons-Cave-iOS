//
//  DCExplosion.swift
//  DemonsCave
//
//  Created by Admin on 20.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import SpriteKit

class DCExplosion : DCObject
{
    weak var dcExplosionDelegate : DCExplosionDelegate?
    var frames = [SKTexture]();
    
    func initializeAnimation()
    {
        let atlas = SKTextureAtlas(named: "Explosion")
        let sorted = atlas.textureNames.sorted()
        
        for textureName in sorted
        {
            let texture = atlas.textureNamed(textureName)
            frames.append(texture)
        }
    }
    
    convenience init()
    {
        
        let atlas = SKTextureAtlas(named: "Explosion")
        self.init(texture: atlas.textureNamed("explosion0"));
        
        self.position = CGPoint(x: 420, y: 340)
        self.zPosition = 24;
        
        self.initializeAnimation();
        self.startAnimation();
    }
    
    func startAnimation()
    {
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.1);
        
        run(animationAction, completion: {
            self.dcExplosionDelegate?.dcExplosionDidFinish(self)
            })
    }
}
