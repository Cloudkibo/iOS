// Author - Santosh Rajan

import Foundation
/*
let jsonObject: [AnyObject] = [
    ["name": "John", "age": 21],
    ["name": "Bob", "age": 35],
]

/*func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
    var options:prettyPrinted=NSJSONWritingOptions.p
    if NSJSONSerialization.isValidJSONObject(value) {
        if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: options) {
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        }
    }
    return ""
}
*/
/*
*  Usage
*/


let jsonString = JSONStringify(jsonObject)
//print("\(jsonString)")
// Prints - [{"age":21,"name":"John"},{"age":35,"name":"Bob"}]

/*
*  Usage - Pretty Printed
*/


let jsonStringPretty = JSONStringify(jsonObject, prettyPrinted: true)
//print(jsonStringPretty)
/*  Prints the following -

[
{
"age" : 21,
"name" : "John"
},
{
"age" : 35,
"name" : "Bob"
}
]

*/
*/


