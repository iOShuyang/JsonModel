//
//  Property.swift
//  JsonModel
//
//  Created by 胡洋 on 2018/2/7.
//  Copyright © 2020年 胡洋. All rights reserved.
//

import Foundation

/// count = 3
let currentMapperSpace = "   "

enum YWPropertyType: Int {
    case `String` = 0
    case `Int`
    case `Float`
    case `Double`
    case `Bool`
    case `Dictionary`
    case ArrayString
    case ArrayInt
    case ArrayFloat
    case ArrayDouble
    case ArrayBool
    case ArrayDictionary
    case `nil` // 目前 nil 的属性 使用 string 类型来替代
}


class Property {
    
    var propertyKey: String
    
    var type: YWPropertyType
    
    var langStruct: LangStruct
    
    var prefixStr: String
    
    init(propertyKey: String, type: YWPropertyType, langStruct: LangStruct, prefixStr: String) {
//        if (propertyKey.contains("_")) {
//            self.propertyKey = propertyKey.capitalized.replacingOccurrences(of: "_", with: "")
//        } else {
//            self.propertyKey = propertyKey
//        }

        self.propertyKey = propertyKey

        self.propertyKey = propertyKey
        self.type = type
        self.langStruct = langStruct
        self.prefixStr = prefixStr
    }
    
    func toString() -> (String, String){
        var propertyStr = ""
        var initStr = ""
        let propertyKeyNormal = propertyKey.className(withPrefix: prefixStr).capitalized.replacingOccurrences(of: "_", with: "").lowercaseFirstChar()
        let propertyKeyCapitalized = propertyKey.className(withPrefix: prefixStr).capitalized.replacingOccurrences(of: "_", with: "")
        switch type {
        case .String:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, copy) NSString *\(propertyKeyNormal);\n"
            case .Swift,.HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal): String?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal): String?\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].stringValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal): String?\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tString \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .Int:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) NSInteger \(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal): Int = 0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal): Int = 0\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].intValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal): Int = 0\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tint \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .Float:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Float \(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal): Float = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal): Float = 0.0\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].floatValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal): Float = 0.0\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tdouble \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .Double:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) Double \(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal): Double = 0.0\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal): Double = 0.0\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].doubleValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal): Double = 0.0\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tdouble \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .Bool:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, assign) BOOL \(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal): Bool = false\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal): Bool = false\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].boolValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal): Bool = false\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tbool \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .Dictionary:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) \(propertyKeyCapitalized) *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal): \(propertyKeyCapitalized)?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal): \(propertyKeyCapitalized)?\n"
                initStr = "\t\t\(propertyKeyNormal) = \(propertyKeyCapitalized)(jsonData: jsonData[\"\(propertyKey)\"])\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal): \(propertyKeyCapitalized)?\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\t\(propertyKey.className(withPrefix: prefixStr)) \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .ArrayString:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<NSString *> *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal) = [String]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal) = [String]()\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].arrayValue.compactMap({$0.stringValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal) = [String]()\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<String> \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .ArrayInt:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Int> *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal) = [Int]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal) = [Int]()\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].arrayValue.compactMap({$0.intValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal) = [Int]()\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<int> \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .ArrayFloat:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Float> *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal) = [Float]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal) = [Float]()\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].arrayValue.compactMap({$0.floatValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal) = [Float]()\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<double> \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .ArrayDouble:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Double> *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal) = [Double]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal) = [Double]()\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].arrayValue.compactMap({$0.doubleValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal) = [Double]()\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<double> \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .ArrayBool:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<Bool> *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal) = [Bool]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal) = [Bool]()\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].arrayValue.compactMap({$0.boolValue})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal) = [Bool]()\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<bool> \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .ArrayDictionary:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, strong) NSArray<\(propertyKeyCapitalized) *> *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal) = [\(propertyKeyCapitalized)]()\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal) = [\(propertyKeyCapitalized)]()\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].arrayValue.compactMap({ \(propertyKeyCapitalized)(jsonData: $0)})\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal) = [\(propertyKeyCapitalized)]()\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tList<\(propertyKeyCapitalized)> \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }
        case .nil:
            switch langStruct.langType{
            case .ObjC:
                propertyStr = "@property (nonatomic, copy) NSString *\(propertyKeyNormal);\n"
            case .Swift, .HandyJSON, .Codable:
                propertyStr = "\tvar \(propertyKeyNormal): String?\n"
            case .SwiftyJSON:
                propertyStr = "\tvar \(propertyKeyNormal): String?\n"
                initStr = "\t\t\(propertyKeyNormal) = jsonData[\"\(propertyKey)\"].stringValue\n"
            case .ObjectMapper:
                propertyStr = "\tvar \(propertyKeyNormal): String?\n"
                initStr = "\t\t\(propertyKeyNormal)\(currentMapperSpace)<- map[\"\(propertyKey)\"]\n"
            case .Flutter:
                propertyStr = "\n\t@JsonKey(name: '\(propertyKey)')\n\tString \(propertyKeyNormal);\n"
                initStr = "this.\(propertyKeyNormal),"
            }

        }
        
        return (propertyStr, initStr)
    }
    
}
