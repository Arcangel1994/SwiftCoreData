//
//  UIButtonExt.swift
//  goalpostApp
//
//  Created by Miguel Muñoz on 12/4/18.
//  Copyright © 2018 ISA. All rights reserved.
//

import UIKit

extension UIButton{
    
    func setSelectedColor(){
        self.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
    }
    
    func setDeselectedColor(){
        self.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 0.5)
    }
    
}
