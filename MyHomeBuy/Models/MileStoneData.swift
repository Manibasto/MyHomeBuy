//
//  MileStoneData.swift
//  MyHomeBuy
//
//  Created by Vikas on 27/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation
var dataArray = [Any]()
class MileStoneData{
    static let sharedInstance   =   MileStoneData()
    
    fileprivate init(){
        
    }
    func getDataDictionary(_ currentMileStoneNo : Int) -> Dictionary<String, Any>{
        switch currentMileStoneNo {
        case 1:
            let data1 = ["image" : "main_budget_icon" , "colorCode" : UIColor.mileStoneColor1 , "colorCodeDark" : UIColor.mileStoneColor11, "text" : "BUDGET"] as [String : Any]
            return data1
        case 2:
            let data2 = ["image" : "main_start_looking_icon" , "colorCode" : UIColor.mileStoneColor2 , "colorCodeDark" : UIColor.mileStoneColor12, "text" : "LET'S START LOOKING"] as [String : Any]
            return data2
        case 3:
            let data3 = ["image" : "main_offer_icon" , "colorCode" : UIColor.mileStoneColor3 , "colorCodeDark" : UIColor.mileStoneColor13, "text" : "OFFER TO PURCHASE"] as [String : Any]
            return data3
        case 4:
            let data4 = ["image" : "main_legal_icon" , "colorCode" : UIColor.mileStoneColor4 , "colorCodeDark" : UIColor.mileStoneColor14, "text" : "LEGAL"] as [String : Any]
            return data4
        case 5:
            let data5 = ["image" : "main_contract_icon" , "colorCode" : UIColor.mileStoneColor5 , "colorCodeDark" : UIColor.mileStoneColor15, "text" : "CONTRACT"] as [String : Any]
            return data5
        case 6:
            let data6 = ["image" : "main_property_settlement_icon" , "colorCode" : UIColor.mileStoneColor6, "colorCodeDark" : UIColor.mileStoneColor16 , "text" : "PROPERTY SETTLEMENT"] as [String : Any]
            return data6
        case 7:
            let data7 = ["image" : "main_moving_icon" , "colorCode" : UIColor.mileStoneColor7 , "colorCodeDark" : UIColor.mileStoneColor17, "text" : "MOVING IN"] as [String : Any]
            return data7
        default :
            return ["as" : "as"]
        }
        
    }
    
    func setupTableData(_ currentMileStoneNo : Int) -> Array<Any>{
        dataArray.removeAll()
        switch currentMileStoneNo {
        case 1:
            createMileStoneDataFor1()
        case 2:
            createMileStoneDataFor2()
        case 3:
            createMileStoneDataFor3()
        case 4:
            createMileStoneDataFor4()
        case 5:
            createMileStoneDataFor5()
        case 6:
            createMileStoneDataFor6()
        case 7:
            createMileStoneDataFor7()
        case 8:
            createMileStoneDataForExistingHome()
        case 9:
            createMileStoneDataForNewHome()
        default:
            
            break
        }
        
        return dataArray
    }
    func createMileStoneDataFor1(){
        let data1 = ["headerText" : "Getting started"  , "image" : "getting_started", "image_white" : "getting_started_white", "colorCode" : UIColor.mileStoneColor1 , "colorCodeDark" : UIColor.mileStoneColor11 , "complete" : "budget_milestone_complete"] as [String : Any]
        let data2 = ["headerText" : "How much can I borrow?" , "image" : "borrow" , "image_white" : "borrow_white", "colorCode" : UIColor.mileStoneColor1 , "colorCodeDark" : UIColor.mileStoneColor11, "complete" : "budget_milestone_complete"] as [String : Any]
        dataArray.append(data1)
        dataArray.append(data2)
        
    }
    func createMileStoneDataFor2(){
        
    }
    func createMileStoneDataFor3(){
        let data1 = ["headerText" : "Things to check before making an offer"  , "image" : "offer_purchase", "image_white" : "offer_purchase_white", "colorCode" : UIColor.mileStoneColor3 , "colorCodeDark" : UIColor.mileStoneColor13, "complete" : "offer_milestone_complete"] as [String : Any]
        let data2 = ["headerText" : "Making an offer to purchase" , "image" : "make_offer", "image_white" : "make_offer_white", "colorCode" : UIColor.mileStoneColor3 , "colorCodeDark" : UIColor.mileStoneColor13 , "complete" : "offer_milestone_complete"] as [String : Any]
        dataArray.append(data1)
        dataArray.append(data2)
    }
    func createMileStoneDataFor4(){
        let data1 = ["headerText" : "Hire a lawyer or conveyancing professional"  , "image" : "lawyer", "image_white" : "lawyer_white", "colorCode" : UIColor.mileStoneColor4 , "colorCodeDark" : UIColor.mileStoneColor14, "complete" : "legal_milestone_complete"] as [String : Any]
        
        dataArray.append(data1)
    }
    func createMileStoneDataFor5(){
        let data1 = ["headerText" : "Contract details"  , "image" : "contract_details", "image_white" : "contract_details_white", "colorCode" : UIColor.mileStoneColor5 , "colorCodeDark" : UIColor.mileStoneColor15, "complete" : "contract_milestone_complete"] as [String : Any]
        let data2 = ["headerText" : "Start preparing your move" , "image" : "preparing_move" , "image_white" : "preparing_move_white", "colorCode" : UIColor.mileStoneColor5 , "colorCodeDark" : UIColor.mileStoneColor15, "complete" : "contract_milestone_complete"] as [String : Any]
        dataArray.append(data1)
        dataArray.append(data2)
    }
    func createMileStoneDataFor6(){
        let data1 = ["headerText" : "Finalising the payment"  , "image" : "finalising_payment", "image_white" : "finalising_payment_white", "colorCode" : UIColor.mileStoneColor6 , "colorCodeDark" : UIColor.mileStoneColor16, "complete" : "property_milestone_complete"] as [String : Any]
        
        dataArray.append(data1)
    }
    func createMileStoneDataFor7(){
        let data1 = ["headerText" : "Plan ahead"  , "image" : "plan_ahead", "image_white" : "plan_ahead_white", "colorCode" : UIColor.mileStoneColor7 , "colorCodeDark" : UIColor.mileStoneColor17, "complete" : "moving_milestone_complete"] as [String : Any]
        
        dataArray.append(data1)
    }
    func createMileStoneDataForExistingHome(){
        let data1 = ["headerText" : "Choosing the location for buying an existing home"  , "image" : "existing_home", "image_white" : "existing_home_white", "colorCode" : UIColor.mileStoneColor2 , "colorCodeDark" : UIColor.mileStoneColor12, "complete" : "lets_milestone_complete"] as [String : Any]
        
        dataArray.append(data1)
    }
    func createMileStoneDataForNewHome(){
        let data1 = ["headerText" : "Choosing the location for building a new home"  , "image" : "building_new", "image_white" : "building_new_white", "colorCode" : UIColor.mileStoneColor2 , "colorCodeDark" : UIColor.mileStoneColor12, "complete" : "lets_milestone_complete"] as [String : Any]
        let data2 = ["headerText" : "Buying vacant land" , "image" : "vacant_land" , "image_white" : "vacant_land_white", "colorCode" : UIColor.mileStoneColor2 , "colorCodeDark" : UIColor.mileStoneColor12, "complete" : "lets_milestone_complete"] as [String : Any]
        let data3 = ["headerText" : "Building a new home" , "image" : "new_home", "image_white" : "new_home_white" , "colorCode" : UIColor.mileStoneColor2 , "colorCodeDark" : UIColor.mileStoneColor12, "complete" : "lets_milestone_complete"] as [String : Any]
        dataArray.append(data1)
        dataArray.append(data2)
        dataArray.append(data3)
    }
}


