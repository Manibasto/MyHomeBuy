/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class DocumentModel {
	public var created_date : String?
	public var id : String?
	public var file_type : String?
	public var task_id : String?
	public var file_name : String?
	public var user_id : String?
	public var updated_date : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [DocumentModel]
    {
        var models:[DocumentModel] = []
        for item in array
        {
            models.append(DocumentModel(dictionary: item as! NSDictionary)!)
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
		file_type = dictionary["file_type"] as? String
		task_id = dictionary["task_id"] as? String
		file_name = dictionary["file_name"] as? String
		user_id = dictionary["user_id"] as? String
		updated_date = dictionary["updated_date"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.created_date, forKey: "created_date")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.file_type, forKey: "file_type")
		dictionary.setValue(self.task_id, forKey: "task_id")
		dictionary.setValue(self.file_name, forKey: "file_name")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.updated_date, forKey: "updated_date")

		return dictionary
	}

}
