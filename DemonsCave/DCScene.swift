//
//  DCScene.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import SpriteKit

class DCScene: SKScene
{
    weak var dcSceneDelegate : DCSceneDelegate?
    weak var gameScoreController : DCGameScoreController?
    weak var soundController : DCSoundController?
    weak var gameViewController : DCGameViewController?
    
    func addChildToScene(_ child : DCObject)
    {
        child.gameScoreController = self.gameScoreController
        child.soundController = soundController
        super.addChild(child)
    }
}
