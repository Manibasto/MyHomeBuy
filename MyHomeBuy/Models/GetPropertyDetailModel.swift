/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class GetPropertyDetailModel {
	public var id : String?
	public var description : String?
	public var bathrooms : String?
	public var area_sqft : String?
	public var user_id : String?
	public var bedrooms : String?
	public var agent_name : String?
	public var price : String?
	public var address : String?
	public var agent_contact : String?
	public var image : String?
	public var created_date : String?
	public var car_parking_garage : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [GetPropertyDetailModel]
    {
        var models:[GetPropertyDetailModel] = []
        for item in array
        {
            models.append(GetPropertyDetailModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let data = Data(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Data Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		description = dictionary["description"] as? String
		bathrooms = dictionary["bathrooms"] as? String
		area_sqft = dictionary["area_sqft"] as? String
		user_id = dictionary["user_id"] as? String
		bedrooms = dictionary["bedrooms"] as? String
		agent_name = dictionary["agent_name"] as? String
		price = dictionary["price"] as? String
		address = dictionary["address"] as? String
		agent_contact = dictionary["agent_contact"] as? String
		image = dictionary["image"] as? String
		created_date = dictionary["created_date"] as? String
		car_parking_garage = dictionary["car_parking_garage"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.bathrooms, forKey: "bathrooms")
		dictionary.setValue(self.area_sqft, forKey: "area_sqft")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.bedrooms, forKey: "bedrooms")
		dictionary.setValue(self.agent_name, forKey: "agent_name")
		dictionary.setValue(self.price, forKey: "price")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.agent_contact, forKey: "agent_contact")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.created_date, forKey: "created_date")
		dictionary.setValue(self.car_parking_garage, forKey: "car_parking_garage")

		return dictionary
	}

}
