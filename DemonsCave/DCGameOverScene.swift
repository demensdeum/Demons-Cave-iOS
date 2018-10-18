//
//  PlayGameInstructionsScene.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit
import Alamofire
import SwiftyJSON
import iAd

class DCGameOverScene: DCScene, ADBannerViewDelegate {
    
    var bannerView: ADBannerView!
    var isWaitForClick = false
    var promptAlertView : UIAlertController!
    
    let topScoreLabel = SKLabelNode.init(fontNamed:"ChelseaMarket-Regular")
    
    var playerNameTextField: UITextField!
    var topScore = 0
    
    override func didMove(to: SKView)
    {
        self.addBanner()
        
        topScoreLabel.isHidden = true
        self.addChild(topScoreLabel)
        self.drawScore()
        self.loadTopScore()
        
        let sprite = SKSpriteNode(imageNamed: "gameOver")
        
        sprite.position = CGPoint(x: 400, y: 240)
        sprite.alpha = 0        
        
        let fromAlpha = SKAction.fadeAlpha(to: 1, duration: 1)
        
        sprite.run(SKAction.sequence([fromAlpha]), completion: {
            
            self.isWaitForClick = true;
            
        });
        
        self.addChild(sprite);
    }
    
    func addBanner()
    {
        self.bannerView = ADBannerView(adType: .banner)
        self.bannerView.delegate = self
        self.bannerView.isHidden = true
        self.gameViewController!.view.addSubview(self.bannerView)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!)
    {
        self.bannerView.isHidden = false
    }
    
    private func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: Error?)
    {
        self.bannerView.isHidden = true
    }
    
    func configurationTextField(textField: UITextField!)
    {
        textField.text = "Werj"
        self.playerNameTextField = textField
        self.playerNameTextField.placeholder = "Player Name"
    }
    
    func cancelButtonPressed(alertView: UIAlertAction!)
    {
    }
    
    func okButtonPressed(alertView: UIAlertAction!)
    {
        self.sendTopScore(self.gameScoreController!.score, playerName: self.playerNameTextField.text!)
    }
    
    func sendTopScore(_ topScore: Int, playerName: String)
    {
        guard let url = URL(string: "http://demensdeum.com/games/demonsCave/backend/topScore/topScoreUploader.php") else { return }
        Alamofire.request(url, method: .post, parameters: ["playerName" : playerName, "score" : topScore])
        
        self.drawTopScore(topScore, playerName: playerName)
        
    }
    
    func askTopUploadScore()
    {
        self.promptAlertView = UIAlertController(title: "You beat top score!", message: "Enter your name (short english)", preferredStyle: .alert)
        self.promptAlertView.addTextField(configurationHandler: configurationTextField)
        self.promptAlertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelButtonPressed))
        self.promptAlertView.addAction(UIAlertAction(title: "OK", style: .default, handler: okButtonPressed))
        self.gameViewController?.present(self.promptAlertView, animated: true, completion: nil)
    }
    
    func handleTopScore(_ topScore: Int, playerName: String)
    {
        self.topScore = topScore
        
        self.drawTopScore(topScore, playerName: playerName)
        
        let score = self.gameScoreController!.score
        
        if (score > topScore)
        {
            self.askTopUploadScore()
        }
    }
    
    func loadTopScore()
    {
        guard let url = URL(string: "http://demensdeum.com/games/demonsCave/backend/topScore/topScoreLoader.php") else { return }
        
        let parameters = [String:Any]()
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self] (response:DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let topScore = json["topScore"]
                let playerName = json["playerName"]
                
                if (self != nil && topScore.string != nil && playerName.string != nil)
                {
                    self!.handleTopScore(Int(topScore.string!)!, playerName: playerName.string!)
                }
                break
            default:
                break
            }
        }
    }
    
    func drawTopScore(_ topScore : Int, playerName : String)
    {
        topScoreLabel.isHidden = false
        topScoreLabel.horizontalAlignmentMode = .left
        topScoreLabel.color = UIColor.white
        topScoreLabel.position = CGPoint(x: 14, y: 40)
        topScoreLabel.zPosition = 99;
        topScoreLabel.text = "Top Score: " + String(topScore) + " by " + playerName
    }
    
    func drawScore()
    {
        let scoreLabel = SKLabelNode.init(fontNamed:"ChelseaMarket-Regular")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.color = UIColor.white
        scoreLabel.position = CGPoint(x: 14, y: 10)
        scoreLabel.zPosition = 99;
        scoreLabel.text = "Score: " + String(self.gameScoreController!.score)
        
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if (self.isWaitForClick)
        {
            self.bannerView.removeFromSuperview()
            self.dcSceneDelegate?.dcSceneDidFinish(self);
        }
    }
    
}
