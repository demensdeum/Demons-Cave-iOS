//
//  DCSpeedBar.swift
//  DemonsCave
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import SpriteKit

class DCSpeedBar
{

    var speedBarSprite : SKSpriteNode;
    var mask : SKSpriteNode;
    var cropNode : SKCropNode;
    
    init()
    {
        self.speedBarSprite = SKSpriteNode(imageNamed: "speedBar")
        self.speedBarSprite.anchorPoint = CGPoint(x:0, y:0.5)
        
        self.cropNode = SKCropNode.init()
        
        let maskSize = CGSize(width: self.speedBarSprite.size.width, height: self.speedBarSprite.size.height)
        
        self.mask = SKSpriteNode.init(color:UIColor.black, size:maskSize)
        self.mask.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        self.cropNode.addChild(self.speedBarSprite)
        self.cropNode.maskNode = self.mask
        
        self.cropNode.position = CGPoint(x: 10, y: 20)
        self.cropNode.zPosition = 34
    }
    
    func setProgress(_ progress : NSInteger)
    {
        self.mask.xScale = CGFloat(progress) / 100
    }
}
