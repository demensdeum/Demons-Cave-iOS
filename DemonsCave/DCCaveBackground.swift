//
//  DCCaveBackground.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit

class DCCaveBackground : DCObject
{
    convenience init()
    {
        self.init(imageNamed: "cave");
     
        self.anchorPoint = CGPoint(x: 0, y: 0);
        
        self.restartAction();
        
        self.position = CGPoint(x: 0, y: 0)
        self.zPosition = 0;
    }
 
    func restartAction()
    {
        let startPositionAction = SKAction.moveBy(x: 800, y: 0, duration: 0);
        let endPositionAction = SKAction.moveBy(x: -800, y:0, duration: 10);
        
        self.run(SKAction.sequence([startPositionAction,endPositionAction]), completion: {
            
            self.restartAction();
            
        });
    }
    
}
