//
//  ChartDataModel.swift
//  MyHomeBuy
//
//  Created by Vikas on 22/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
class ChartDataModel{
var chartArray = [Any]()
    init() {
        
    }
    
    

    func getMileStoneName(_ currentMileStone : Int , _ mainMileStoneStone : Int) -> String{
        var name = ""
//        if(currentMileStone >= mainMileStoneStone){
//        return name
//        }
        switch currentMileStone {
            
        case 1:
            name = "Budget"
            break
        case 2:
            name = "Let's Start Looking"

            break
        case 3:
            name = "Offer to Purchase"

            break
        case 4:
            name = "Legal"

            break
        case 5:
            name = "Contract"

            break
        case 6:
            name = "Property Settlement"

            break
        case 7:
            name = "Moving In"

            break
        default:
            break
        }
        return name
    }
    func getMileStoneColor(_ currentMileStone : Int , _ mainMileStoneStone : Int) -> UIColor{
    var color = UIColor.graphColor
        if(currentMileStone >= mainMileStoneStone){
            return color
        }
        switch currentMileStone {
        case 1:
            color = UIColor.mileStoneColor1

            break
        case 2:
            color = UIColor.mileStoneColor2

            break
        case 3:
            color = UIColor.mileStoneColor3

            break
        case 4:
            color = UIColor.mileStoneColor4

            break
        case 5:
            color = UIColor.mileStoneColor5

            break
        case 6:
            color = UIColor.mileStoneColor6

            break
        case 7:
            color = UIColor.mileStoneColor7

            break
        default:
            break
        }
        return color
    }
    
    func getChartdata(_ mainMileStoneNo : Int){
        let data = [ ["name":getMileStoneName(1, mainMileStoneNo), "value": 1,
                             "color": getMileStoneColor(1, mainMileStoneNo), "labelColor" : UIColor.customBlackColor , "strokeColor" : UIColor.white],
                            ["name":getMileStoneName(2, mainMileStoneNo), "value": 1, "color":getMileStoneColor(2, mainMileStoneNo), "labelColor" : UIColor.customBlackColor, "strokeColor" : UIColor.white],
                            ["name":getMileStoneName(3, mainMileStoneNo), "value": 1, "color": getMileStoneColor(3, mainMileStoneNo), "labelColor" : UIColor.customBlackColor, "strokeColor" : UIColor.white],
                            ["name":getMileStoneName(4, mainMileStoneNo), "value": 1, "color" :getMileStoneColor(4, mainMileStoneNo), "labelColor" : UIColor.customBlackColor, "strokeColor" : UIColor.white],
                            ["name":getMileStoneName(5, mainMileStoneNo), "value": 1, "color" : getMileStoneColor(5, mainMileStoneNo), "labelColor" : UIColor.customBlackColor, "strokeColor" : UIColor.white],
                            ["name":getMileStoneName(6, mainMileStoneNo), "value": 1, "color" : getMileStoneColor(6, mainMileStoneNo), "labelColor" : UIColor.customBlackColor, "strokeColor" : UIColor.white],
                            ["name":getMileStoneName(7, mainMileStoneNo), "value": 1, "color":getMileStoneColor(7, mainMileStoneNo), "labelColor" : UIColor.customBlackColor, "strokeColor" : UIColor.white]
            ];
        chartArray = data
    }
    
    func getProperData(_ statusArray : [String]){
        chartArray.removeAll()
        let nameArray = ["Budget","Let's Start Looking","Offer to Purchase","Legal","Contract","Property Settlement","Moving In"]
        let colorArray = [UIColor.mileStoneColor1,UIColor.mileStoneColor2,UIColor.mileStoneColor3,UIColor.mileStoneColor4,UIColor.mileStoneColor5,UIColor.mileStoneColor6,UIColor.mileStoneColor7]
//        if(statusArray.count == 0){
//        statusArray = ["0","0","0","0","0","0","0"]
//        }
        for (index,name) in nameArray.enumerated() {
            let data = ["name":name, "value": 1,
                        "color": statusArray[index] == "0" ? UIColor.graphColor : colorArray[index] , "labelColor" : UIColor.customBlackColor , "strokeColor" : UIColor.white] as [String : Any]
            chartArray.append(data)
        }
       
         

        
    }
    
}
