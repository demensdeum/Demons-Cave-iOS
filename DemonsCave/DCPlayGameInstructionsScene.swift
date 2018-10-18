//
//  PlayGameInstructionsScene.swift
//  DemonsCave
//
//  Created by Admin on 12.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit
import SpriteKit
import SafariServices

class DCPlayGameInstructionsScene: DCScene {
    
    var isWaitForClick = false;
    var button = UIButton.init(type: .custom)
    
    override func didMove(to view: SKView) {
        
        self.addInfoButton()
        
        let sprite = SKSpriteNode(imageNamed: "playButton")
        
        sprite.position = CGPoint(x: 400, y: 240)
        sprite.alpha = 0
        
        let fromAlpha = SKAction.fadeAlpha(to: 1, duration: 1)
        
        sprite.run(SKAction.sequence([fromAlpha]), completion: {
            
            self.isWaitForClick = true;
            
        });
        
        self.addChild(sprite);
    }
    
    func addInfoButton()
    {
        button.setImage(UIImage.init(named: "infoButton"), for: .normal)
        button.frame = CGRect(x: 32, y: 32, width: 32, height: 32)
        button.addTarget(self, action: #selector(infoButtonClicked(button:)), for: .touchUpInside)
        self.gameViewController!.view.addSubview(button)
    }
    
    @objc func infoButtonClicked(button : UIButton)
    {
        let url = URL(string: "http://demensdeum.com/games/demonsCave/info.html")
        
        if #available(iOS 9.0, *) {
            let browserViewController = SFSafariViewController.init(url:url!)
            self.gameViewController?.present(browserViewController, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if (self.isWaitForClick)
        {
            button.removeFromSuperview()
            self.dcSceneDelegate?.dcSceneDidFinish(self);
        }
    }
    
}
