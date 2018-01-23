//
//  AddPropertyModel.swift
//  MyHomeBuy
//
//  Created by Vikas on 11/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import Foundation

class AddPropertyModel{
    var price = ""
    var area_sqft = ""
    var bedrooms = "1"
    var bathrooms = "1"
    var car_parking_garage = "1"
    var address = ""
    var description = ""
    var agent_name = ""
    var agent_contact = ""
    var dataArray = [String]()
    func initArray(){
        dataArray.append(price)
        dataArray.append(area_sqft)
        dataArray.append(bedrooms)
        dataArray.append(bathrooms)
        dataArray.append(car_parking_garage)
        dataArray.append(address)
        dataArray.append(description)
        dataArray.append(agent_name)
        dataArray.append(agent_contact)

    }
    
    func isValidForSubmission()->String{
        for (index , value) in dataArray .enumerated(){
            switch index {
            case 0:
                price = dataArray[index]
                if(value == ""){
                    return "Please enter price"
                }
                break
            case 1:
                area_sqft = dataArray[index]
                
                break
            case 2:
                bedrooms = dataArray[index]
                break
            case 3:
                bathrooms = dataArray[index]
                break
            case 4:
                car_parking_garage = dataArray[index]
                break
            case 5:
                address = dataArray[index]
                if(value == ""){
                    return "Please enter address"
                }
                break
            case 6:
                description = dataArray[index]
                break
            case 7:
                agent_name = dataArray[index]
                break
            case 8:
                agent_contact = dataArray[index]
                break
            default:
                break
            }
            
//            if(value == ""){
//            return false
//            }
        }
    return "OK"
        
    }
    
}

