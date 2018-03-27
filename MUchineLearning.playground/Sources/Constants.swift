/*:
 ## Constants file
 Here some contants used in the playground
 */

import Foundation

public enum AudioEnum {
    public static let SAMPLE_RATE = 44_100.0
    public static let FREQUENCY = 130.0
    public static let AMPLITUDE = 0.25
    public static let THETA = 0.0
    public static let BUFFER_CAPACITY = 512
}

public enum TonesEnum {
    public static let NO_CEILING : Double = 0.0
    public static let NO_HAND : Double = 0.1
    public static let HAND : Double = 0.1
    public static let CEILING : Double = 0.0

    public static let HAND_0 : Double = 0.0
    public static let HAND_1 : Double = 1.0
    public static let HAND_2 : Double = 2.0
    public static let HAND_3 : Double = 3.0
    public static let HAND_4 : Double = 4.0
    public static let HAND_5 : Double = 5.0
    public static let HAND_6 : Double = 6.0

}

public enum ModelStatesStringEnum {
    
    public static let NO_CEILING = "no_ceiling"
    public static let NO_HAND = "no_hand"
    public static let HAND = "hand"
    public static let CEILING = "ceiling"
    public static let HAND_0 = "hand_0"
    public static let HAND_1 = "hand_1"
    public static let HAND_2 = "hand_2"
    public static let HAND_3 = "hand_3"
    public static let HAND_4 = "hand_4"
    public static let HAND_5 = "hand_5"
    public static let HAND_6 = "hand_6"
}

public enum InstrumentsEnum {
    public static let SYNTH = 4
    public static let BAND = 3
    public static let GUITAR = 2
    public static let DRUM = 1
    public static let PIANO = 0
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

