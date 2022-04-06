//
//  CarnivalWheelSlice.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 06/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import TTFortuneWheel

public class CarnivalWheelSlice: FortuneWheelSliceProtocol {
    
    public enum Style {
        case brickRed
        case sandYellow
        case babyBlue
        case deepBlue
    }
    
    public var title: String
    public var secondtitle : String
    public var degree: CGFloat = 0.0
    
    public var backgroundColor: UIColor? {
        switch style {
        case .brickRed: return TTUtils.uiColor(from:0xE63B3B)
        case .sandYellow: return TTUtils.uiColor(from:0x28B071)
        case .babyBlue: return TTUtils.uiColor(from:0xF6A31A)
        case .deepBlue: return TTUtils.uiColor(from:0x2C9CD8)
        }
    }

    public var fontColor: UIColor {
        return UIColor.white
    }
    
    public var offsetFromExterior:CGFloat {
        return 10.0
    }
    
    public var font: UIFont {
        switch style {
        case .brickRed: return UIFont(name: "Roboto-Regular", size: 11.0)!
        case .sandYellow: return UIFont(name:"Roboto-Regular", size: 11.0)!
        case .babyBlue: return UIFont(name: "Roboto-Regular", size: 11.0)!
        case .deepBlue: return UIFont(name: "Roboto-Regular", size: 11.0)!
        }
    }
    
    public var stroke: StrokeInfo? {
        return StrokeInfo(color: UIColor.white, width: 1.0)
    }
    
    public var style:Style = .brickRed
    
    public init(title:String,sectitle:String) {
        self.title = title
        self.secondtitle = sectitle
    }
    
    public convenience init(title:String,othertitle:String, degree:CGFloat) {
        self.init(title:title,sectitle:othertitle)
        self.degree = degree
    }
}
