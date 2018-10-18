//
//  DCUtils.swift
//  DemonsCave
//
//  Created by Admin on 19.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import UIKit

class DCUtils: NSObject {

    static func randomBool() -> Bool
    {
        let random = arc4random() % 100;
        
        if (random > 50)
        {
            return true
        }
        else
        {
            return false
        }
    }
}
