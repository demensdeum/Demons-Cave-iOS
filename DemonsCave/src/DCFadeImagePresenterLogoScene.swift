//
//  DemensdeumLogoScene.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit

class DCFadeImagePresenterLogoScene: DCScene {

    var imageNamed: String;
    
    init(imageNamed: String)
    {
        self.imageNamed = imageNamed;
        super.init(size: CGSize(width: 800, height: 480))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let sprite = SKSpriteNode(imageNamed: self.imageNamed)
        
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.alpha = 0
        
        let duration = 2.0;

        let fromAlpha = SKAction.fadeAlpha(to: 1, duration: 1)
        let toAlpha = SKAction.fadeAlpha(to: 0, duration: 1)
        
        let wait = SKAction.wait(forDuration: duration);
        
        sprite.run(SKAction.sequence([fromAlpha,wait,toAlpha]), completion: {
            
            self.dcSceneDelegate?.dcSceneDidFinish(self);
            
        });
        
        self.addChild(sprite);
    }
    
}
