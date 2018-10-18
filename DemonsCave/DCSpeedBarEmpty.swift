//
//  DCSpeedBar.swift
//  DemonsCave
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import SpriteKit

class DCSpeedBarEmpty : DCObject
{
    convenience init()
    {
        self.init(imageNamed: "speedBarEmpty");
        
        self.position = CGPoint(x: 150, y:20)
        
        self.zPosition = 33;
    }
}
