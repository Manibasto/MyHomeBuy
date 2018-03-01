/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class EventModel {
	public var created_date : String?
	public var id : String?
	public var task_id : String?
	public var subject : String?
	public var user_id : String?
	public var date : String?
    public var time : String?
	public var description : String?
    public var reminder : String?
    public var event_id : String?


   // reminder

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [EventModel]
    {
        var models:[EventModel] = []
        for item in array
        {
            models.append(EventModel(dictionary: item as! NSDictionary)!)
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

		created_date = dictionary["created_date"] as? String
		id = dictionary["id"] as? String
		task_id = dictionary["task_id"] as? String
		subject = dictionary["subject"] as? String
		user_id = dictionary["user_id"] as? String
		date = dictionary["date"] as? String
		description = dictionary["description"] as? String
        time = dictionary["time"] as? String
        reminder = dictionary["reminder"] as? String
        event_id = dictionary["event_id"] as? String



	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.created_date, forKey: "created_date")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.task_id, forKey: "task_id")
		dictionary.setValue(self.subject, forKey: "subject")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.date, forKey: "date")
		dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.time, forKey: "time")

		return dictionary
	}

}
