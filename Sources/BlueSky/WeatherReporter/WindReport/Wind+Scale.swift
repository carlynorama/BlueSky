//
//  Wind+Scale.swift
//  
//
//  Created by Labtanza on 6/29/22.
//

import Foundation
import WeatherKit

extension Wind {
    var asStandardUnits:(direction:Double, speed:Double, gust:Double?) {
        (
            direction:direction.converted(to: .radians).value,
            speed:speed.converted(to: .metersPerSecond).value,
            gust:gust?.converted(to: .metersPerSecond).value
        )
    }
    
    var extendedWindScaleRating:WindScaleValue? {
        for (index, level) in windLevels.enumerated() {
            if (level.windSpeedMin...level.windSpeedMax).contains(self.speed) {
                return WindScaleValue(rawValue: index)
            }
        }
        return nil
    }
    
    public var calculatedBeaufortScale:Double {
        // v knots = (13/8) B^3/2
        // where:
        // v is the equivalent wind speed at 10 metres above the sea surface and
        // B is Beaufort scale number
        // v * (8/13) = B^(3/2)
        // (v * (8/13))^(2/3) = B
        return Self.calculateBeaufortScale(for: self.speed)
    }
    
    static func calculateBeaufortScale(for speed:Measurement<UnitSpeed>) -> Double {
        return pow(speed.converted(to: .knots).value * (8.0/13), (2.0/3.0))
    }

}

struct WindScaleLevelDescription {
    let force:Int
    let windSpeedMin:Measurement<UnitSpeed>
    let windSpeedMax:Measurement<UnitSpeed>
    let waveHeightMin:Measurement<UnitLength>
    let waveHeightMax:Measurement<UnitLength>
    let description:String
    let useAtSea:String
    let useOnLand:String
}

public enum WindScaleValue:Int {
    case calm = 0,
         lightAir,
         lightBreeze,
         gentleBreeze,
         moderateBreeze,
         freshBreeze,
         strongBreeze,
         nearGale,
         gale,
         severeGale,
         storm,
         hurricane
}

public extension WindScaleValue {
    var force:Int {
        windLevels[self.rawValue].force
    }
    
    var description:String {
        windLevels[self.rawValue].description
    }
    
    var windSpeedMin:Measurement<UnitSpeed> {
        windLevels[self.rawValue].windSpeedMin
    }
    var windSpeedMax:Measurement<UnitSpeed> {
        windLevels[self.rawValue].windSpeedMax
    }
    var waveHeightMin:Measurement<UnitLength> {
        windLevels[self.rawValue].waveHeightMin
    }
    var waveHeightMax:Measurement<UnitLength> {
        windLevels[self.rawValue].waveHeightMax
    }

    var useAtSea:String {
        windLevels[self.rawValue].useAtSea
    }
    var useOnLand:String {
        windLevels[self.rawValue].useOnLand
    }
}

//enum CompressedWindScale {
//    case calm,  //0-3
//         light, //3-5
//         gentle, //5-10
//         breezy,  //10-20 15 and 25 mph during mild weather, brisk blustery when cold
//         windy,   //20-30
//         veryWindy,  //30-40 //Very Windy
//         strong,    //40-60
//         hurricane //60+
//}

//    enum CompressedWindScale {
//        case calm,
//             light,
//             breezy,
//             windy,
//             strong,
//             huricane
//    }


var windLevels:[WindScaleLevelDescription] {
    [WindScaleLevelDescription(force: 0,
                    windSpeedMin: Measurement(value: 0, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 1, unit: UnitSpeed.knots),
                    waveHeightMin: Measurement(value: 0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 0, unit: UnitLength.meters),
                    description: "Calm",
                    useAtSea: "Sea like a mirror.",
                    useOnLand: "Calm; smoke rises vertically."),
     WindScaleLevelDescription(force: 1,
                    windSpeedMin: Measurement(value: 2, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 3, unit: UnitSpeed.knots),
                    waveHeightMin: Measurement(value: 0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 0.3, unit: UnitLength.meters),
                    description: "Light Air",
                    useAtSea: "Ripples with the appearance of scales are formed, but without foam crests.",
                    useOnLand: "Direction of wind shown by smoke drift, but not by wind vanes."),
     WindScaleLevelDescription(force: 2,
                    windSpeedMin: Measurement(value: 4, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 6, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 0.3, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 0.6, unit: UnitLength.meters),
                    description: "Light Breeze",
                    useAtSea: "Small wavelets, still short, but more pronounced. Crests have a glassy appearance and do not break.",
                    useOnLand: "Wind felt on face; leaves rustle; ordinary vanes moved by wind."),
     WindScaleLevelDescription(force: 3,
                    windSpeedMin: Measurement(value: 7, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 10, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 0.6, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 1.2, unit: UnitLength.meters),
                    description: "Gentle Breeze",
                    useAtSea: "Large wavelets. Crests begin to break. Foam of glassy appearance. Perhaps scattered white horses.",
                    useOnLand: "Leaves and small twigs in constant motion; wind extends light flag."),
     WindScaleLevelDescription(force: 4,
                    windSpeedMin: Measurement(value: 11, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 16, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 1.0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 2.0, unit: UnitLength.meters),
                    description: "Moderate Breeze",
                    useAtSea: "Small waves, becoming larger; fairly frequent white horses.",
                    useOnLand: "Raises dust and loose paper; small branches are moved."),
     WindScaleLevelDescription(force: 5,
                    windSpeedMin: Measurement(value: 17, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 21, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 2.0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 3.0, unit: UnitLength.meters),
                    description: "Fresh Breeze",
                    useAtSea: "Moderate waves, taking a more pronounced long form; many white horses are formed.",
                    useOnLand: "Small trees in leaf begin to sway; crested wavelets form on inland waters."),
     WindScaleLevelDescription(force: 6,
                    windSpeedMin: Measurement(value: 22, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 27, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 3.0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 4.0, unit: UnitLength.meters),
                    description: "Strong Breeze",
                    useAtSea: "Large waves begin to form; the white foam crests are more extensive everywhere.",
                    useOnLand: "Large branches in motion; whistling heard in telegraph wires; umbrellas used with difficulty."),
     WindScaleLevelDescription(force: 7,
                    windSpeedMin: Measurement(value: 28, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 33, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 4.0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 5.5, unit: UnitLength.meters),
                    description: "Near Gale",
                    useAtSea: "Sea heaps up and white foam from breaking waves begins to be blown in streaks along the direction of the wind.",
                    useOnLand: "Whole trees in motion; inconvenience felt when walking against the wind."),
     WindScaleLevelDescription(force: 8,
                    windSpeedMin: Measurement(value: 34, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 40, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 5.5, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 7.5, unit: UnitLength.meters),
                    description: "Gale",
                    useAtSea: "Moderately high waves of greater length; edges of crests begin to break into spindrift. The foam is blown in well-marked streaks along the direction of the wind.",
                    useOnLand: "Breaks twigs off trees; generally impedes progress."),
     WindScaleLevelDescription(force: 9,
                    windSpeedMin: Measurement(value: 41, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 47, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 7.0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 10.0, unit: UnitLength.meters),
                    description: "Severe Gale",
                    useAtSea: "High waves. Dense streaks of foam along the direction of the wind. Crests of waves begin to topple, tumble and roll over. Spray may affect visibility",
                    useOnLand: "Slight structural damage occurs (chimney-pots and slates removed)"),
     WindScaleLevelDescription(force: 10,
                    windSpeedMin: Measurement(value: 48, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 55, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 9.0, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 12.5, unit: UnitLength.meters),
                    description: "Storm",
                    useAtSea: "Very high waves with long overhanging crests. The resulting foam, in great patches, is blown in dense white streaks along the direction of the wind. On the whole the surface of the sea takes on a white appearance. The tumbling of the sea becomes heavy and shock-like. Visibility affected.",
                    useOnLand: "Seldom experienced inland; trees uprooted; considerable structural damage occurs."),
     WindScaleLevelDescription(force: 11,
                    windSpeedMin: Measurement(value: 56, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 63, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 11.5, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 16, unit: UnitLength.meters),
                    description: "Violent Storm",
                    useAtSea: "Exceptionally high waves (small and medium-size ships might be for a time lost to view behind the waves). The sea is completely covered with long white patches of foam lying along the direction of the wind. Everywhere the edges of the wave crests are blown into froth. Visibility affected.",
                    useOnLand: "Very rarely experienced; accompanied by wide-spread damage."),
     WindScaleLevelDescription(force: 12,
                    windSpeedMin: Measurement(value: 64, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 82, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 14, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 17, unit: UnitLength.meters),
                    description: "Hurricane",
                    useAtSea: "The air is filled with foam and spray. Sea completely white with driving spray; visibility very seriously affected.",
                    useOnLand: "Very dangerous winds will produce some damage: Well-constructed frame homes could have damage to roof, shingles, vinyl siding and gutters. Large branches of trees will snap and shallowly rooted trees may be toppled. Extensive damage to power lines and poles likely will result in power outages that could last a few to several days. "),
     WindScaleLevelDescription(force: 13,
                    windSpeedMin: Measurement(value: 83, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 95, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 14, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 19, unit: UnitLength.meters),
                    description: "Hurricane 2",
                    useAtSea: "The air is filled with foam and spray. The sea is completely white with driving spray. Visibility is seriously affected.",
                    useOnLand: "Extremely dangerous winds will cause extensive damage: Well-constructed frame homes could sustain major roof and siding damage. Many shallowly rooted trees will be snapped or uprooted and block numerous roads. Near-total power loss is expected with outages that could last from several days to weeks."),
     WindScaleLevelDescription(force: 14,
                    windSpeedMin: Measurement(value: 96, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 112, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 14, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 50, unit: UnitLength.meters),
                    description: "Hurricane 3",
                    useAtSea: "The air is filled with foam and spray. The sea is completely white with driving spray. Visibility is seriously affected.",
                    useOnLand: "Devastating damage will occur: Well-built framed homes may incur major damage or removal of roof decking and gable ends. Many trees will be snapped or uprooted, blocking numerous roads. Electricity and water will be unavailable for several days to weeks after the storm passes. "),
     WindScaleLevelDescription(force: 15,
                    windSpeedMin: Measurement(value: 83, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 95, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 15, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 20, unit: UnitLength.meters),
                    description: "Hurricane 4",
                    useAtSea: "The air is filled with foam and spray. The sea is completely white with driving spray. Visibility is seriously affected.",
                    useOnLand: "Catastrophic damage will occur: Well-built framed homes can sustain severe damage with loss of most of the roof structure and/or some exterior walls. Most trees will be snapped or uprooted and power poles downed. Fallen trees and power poles will isolate residential areas. Power outages will last weeks to possibly months. Most of the area will be uninhabitable for weeks or months."),
     WindScaleLevelDescription(force: 16,
                    windSpeedMin: Measurement(value: 137, unit: UnitSpeed.knots),
                    windSpeedMax: Measurement(value: 252, unit: UnitSpeed.knots) ,
                    waveHeightMin: Measurement(value: 16, unit: UnitLength.meters),
                    waveHeightMax: Measurement(value: 30, unit: UnitLength.meters),
                    description: "Hurricane 5",
                    useAtSea: "The air is filled with foam and spray. The sea is completely white with driving spray. Visibility is seriously affected.",
                    useOnLand: "Catastrophic damage will occur: A high percentage of framed homes will be destroyed, with total roof failure and wall collapse. Fallen trees and power poles will isolate residential areas. Power outages will last for weeks to possibly months. Most of the area will be uninhabitable for weeks or months."),
    ]
}


