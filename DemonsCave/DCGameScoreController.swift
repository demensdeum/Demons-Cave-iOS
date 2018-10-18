//
//  GameScore.swift
//  DemonsCave
//
//  Created by Admin on 22.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

class DCGameScoreController
{
    weak var dcGameScoreControllerDelegate : DCGameScoreControllerDelegate?
    var score = 0;
    
    func addScore(_ score : Int)
    {
        self.score += score
        self.dcGameScoreControllerDelegate?.dcGameScoreControllerScoreAdded(self)
    }
    
    func resetScore()
    {
        self.score = 0
    }
}
