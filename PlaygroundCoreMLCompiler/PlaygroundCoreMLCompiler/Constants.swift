//
//  Constants.swift
//  PlaygroundCoreMLCompiler
//
//  Created by Vincenzo Aceto on 23/03/2018.
//  Copyright © 2018 Vincenzo Aceto. All rights reserved.
//

import Foundation

public enum GuitarSoundsEnum {
    
    public static let HAND_0 = "no_ceiling"
    public static let HAND_1 = "no_ceiling"
    public static let HAND_2 = "no_ceiling"
    public static let HAND_3 = "no_ceiling"
    public static let HAND_4 = "no_ceiling"
    public static let HAND_5 = "no_ceiling"
    
}


public enum InstrumentsEnum {
    public static let GUITAR = 2
    public static let DRUM = 1
    public static let BAND = 0

}

public enum ModelStatesEnum {
    
    public static let NO_CEILING = -1
    public static let NO_HAND = -1
    public static let HAND = -1
    public static let CEILING = -1
    public static let HAND_0 = 0
    public static let HAND_1 = 1
    public static let HAND_2 = 2
    public static let HAND_3 = 3
    public static let HAND_4 = 4
    public static let HAND_5 = 5
    public static let HAND_6 = 6
}
