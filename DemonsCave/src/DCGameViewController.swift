//
//  GameViewController.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright (c) 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameplayKit

enum DCGameState
{
    case
    DemensdeumLogo,
    FlameEngineLogo,
    StartGameScreen,
    InGame,
    GameOver
}

class DCGameViewController: UIViewController, DCSceneDelegate {

    var state : DCGameState = DCGameState.InGame
    weak var skView : SKView?
    var musicPlayer = AVQueuePlayer.init(items:[])
    var gameScoreController = DCGameScoreController()
    var soundController = DCSoundController()
    weak var dcScene : DCScene?
    
    func dcSceneDidFinish(_ scene: DCScene) {
        self.switchGameState();
        self.showGameSceneByState();
    }
    
    func switchGameState()
    {
        switch (self.state)
        {
            
        case .DemensdeumLogo:
            self.state = DCGameState.FlameEngineLogo;
            break;
            
        case .FlameEngineLogo:
            self.state = DCGameState.StartGameScreen;
            break;
            
        case .StartGameScreen:
            self.state = DCGameState.InGame;
            break;
            
        case .InGame:
            self.state = DCGameState.GameOver;
            break;
            
        case .GameOver:
            self.state = DCGameState.InGame;
            break;
            
        }
    }
    
    func showGameSceneByState()
    {
        switch (self.state)
        {
            
        case .DemensdeumLogo:
            self.showDemensdeumLogo();
            break;
            
        case .FlameEngineLogo:
            self.showFlameEngineLogo();
            break;
            
        case .StartGameScreen:
            self.showStartGameScreen();
            break;
            
        case .InGame:
            self.showInGame();
            break;
            
        case .GameOver:
            self.showGameOver();
            break;
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.startGame();
    }
    
    func startGame()
    {
        self.soundController.addSound("coin")
        self.soundController.addSound("explosion")
        self.soundController.addSound("speedUp")
        
        let trackList = [
            AVPlayerItem.init(url: Bundle.main.url(forResource:"bensound-funkyelement", withExtension: "m4a")!),
            AVPlayerItem.init(url: Bundle.main.url(forResource:"bensound-dance", withExtension: "m4a")!),
            AVPlayerItem.init(url: Bundle.main.url(forResource:"bensound-dubstep", withExtension: "m4a")!),
            AVPlayerItem.init(url: Bundle.main.url(forResource:"bensound-moose", withExtension: "m4a")!),
            AVPlayerItem.init(url: Bundle.main.url(forResource:"michett-bitch-please", withExtension: "m4a")!),
            AVPlayerItem.init(url: Bundle.main.url(forResource:"michett-planes", withExtension: "m4a")!),
            AVPlayerItem.init(url: Bundle.main.url(forResource:"bensound-popdance", withExtension: "m4a")!)
        ]
        
        var randomizedTrackList = trackList;
        
        if #available(iOS 9.0, *) {
            randomizedTrackList = GKRandomSource.sharedRandom().arrayByShufflingObjects(in:trackList) as! [AVPlayerItem]
        } else {
            // Fallback on earlier versions
        }
        
        self.musicPlayer = AVQueuePlayer.init(items: randomizedTrackList)
        self.musicPlayer.play()
        
        self.state = .DemensdeumLogo
        self.showGameSceneByState()
    }
    
    func showScene(_ scene : DCScene)
    {
        dcScene = scene
        
        scene.gameViewController = self
        scene.gameScoreController = self.gameScoreController
        scene.soundController = self.soundController
        
        self.skView = self.view as? SKView;
        self.skView!.backgroundColor = UIColor.black
        
        //self.skView!.showsFPS = true
        //self.skView!.showsNodeCount = true
        
        self.skView!.ignoresSiblingOrder = true
        
        scene.scaleMode = .fill
        scene.dcSceneDelegate = self
        
        //self.skView?.showsPhysics = true
        
        self.skView!.presentScene(scene)
    }
    
    func showDemensdeumLogo()
    {
        self.showScene(DCFadeImagePresenterLogoScene(imageNamed: "demensdeumLogo"))
    }
    
    func showFlameEngineLogo()
    {
        self.showScene(DCFadeImagePresenterLogoScene(imageNamed: "flameSteelEngineLogo"))
    }
    
    func showStartGameScreen()
    {
        self.showScene(DCPlayGameInstructionsScene(size: CGSize(width: 800, height:480)))
    }
    
    func showInGame()
    {
        self.showScene(DCInGameScene());
    }
    
    func showGameOver()
    {
        self.showScene(DCGameOverScene(size: CGSize(width: 800, height:480)))
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
