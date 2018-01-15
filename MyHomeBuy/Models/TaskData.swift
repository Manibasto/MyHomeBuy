/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class TaskData {
	public var milestone_cat_id : String?
	public var id : String?
	public var status : String?
	public var name : String?
    public var calculation : String?
    public var value : String?


/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [TaskData]
    {
        var models:[TaskData] = []
        for item in array
        {
            models.append(TaskData(dictionary: item as! NSDictionary)!)
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

		milestone_cat_id = dictionary["milestone_cat_id"] as? String
		id = dictionary["id"] as? String
		status = dictionary["status"] as? String
        name = dictionary["name"] as? String
        calculation = dictionary["calculation"] as? String

        value = dictionary["value"] as? String

	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.milestone_cat_id, forKey: "milestone_cat_id")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.calculation, forKey: "calculation")
        dictionary.setValue(self.value, forKey: "value")

		return dictionary
	}

}
