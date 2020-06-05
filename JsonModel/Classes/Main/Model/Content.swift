//
//  YWContent.swift
//  JsonModel
//
//  Created by 胡洋 on 2018/2/7.
//  Copyright © 2020年 胡洋. All rights reserved.
//

import Foundation

class Content {
    var properties = [Property]()
    
    var propertyKey: String
    
    var langStruct: LangStruct
    
    var superClass: String
    
    var prefixStr: String
    
    init(propertyKey: String, langStruct: LangStruct, superClass: String, prefixStr: String) {
        self.propertyKey = propertyKey
        self.langStruct = langStruct
        self.superClass = superClass
        self.prefixStr = prefixStr
    }
    
    func toString() -> String {
        let className = propertyKey.contains("_") ? propertyKey.className(withPrefix: prefixStr).capitalized.replacingOccurrences(of: "_", with: ""):propertyKey.className(withPrefix: prefixStr)
        var contentStr = ""
        
        let result = propertyAndInitPart()
        var propertyTotalPart = result.0
        let initTotalPart = result.1
        
        switch langStruct.langType {
        case .ObjC:
            propertyTotalPart.removeLastChar()
            contentStr = "\n@interface \(className)\(superClassNamePart())\n\(propertyTotalPart)\n@end\n"
        case .Swift:
            propertyTotalPart.removeLastChar()
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n}\n"
            }
        case .HandyJSON, .Codable:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\trequired init() {}\n}\n"
            }else if langStruct.structType == .struct {
                propertyTotalPart.removeLastChar()
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n}\n"
            }
        case .SwiftyJSON:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\tinit?(jsonData: JSON) {\n\(initTotalPart)\t}\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\tinit?(jsonData: JSON) {\n\(initTotalPart)\t}\n}\n"
            }
        case .ObjectMapper:
            if langStruct.structType == .class {
                contentStr = "\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\trequired init?(map: Map) {}\n\n\tfunc mapping(map: Map) {\n\(initTotalPart)\t}\n}\n"
            }else if langStruct.structType == .struct {
                contentStr = "\nstruct \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\tinit?(map: Map) {}\n\n\tmutating func mapping(map: Map) {\n\(initTotalPart)\t}\n}\n"
            }
        case .Flutter:
            contentStr = "\n@JsonSerializable()\nclass \(className)\(superClassNamePart()) {\n\(propertyTotalPart)\n\t\(className)(\(initTotalPart));\n\n\tfactory \(className).fromJson(Map<String, dynamic> srcJson) => _$\(className)FromJson(srcJson);\n\n\tMap<String, dynamic> toJson() => _$\(className)ToJson(this);\n\n}\n"
        }
        
        return contentStr
    }
    
    private func propertyAndInitPart() -> (String, String) {
        var propertyStr = ""
        var initSwiftStr = ""

        properties.forEach({ (property) in
            let result = property.toString()
            propertyStr += result.0
            initSwiftStr += result.1
        })
        
        return (propertyStr, initSwiftStr)
    }
    
    private func superClassNamePart() -> String {
        var superClassPart: String = ""
        
        switch langStruct.langType {
        case .HandyJSON:
            superClassPart = superClass.isEmpty ? ": HandyJSON" : ": \(superClass)"
        case .Swift, .SwiftyJSON:
            superClassPart = superClass.isEmpty ? "" : ": \(superClass)"
        case .ObjC:
            superClassPart = superClass.isEmpty ? ": NSObject" : ": \(superClass)"
        case .ObjectMapper:
            superClassPart = superClass.isEmpty ? ": Mappable" : ": \(superClass)"
        case .Flutter:
            superClassPart = superClass.isEmpty ? " extends Object" : " extends \(superClass)"
        case .Codable:
            superClassPart = superClass.isEmpty ? ": Codable" : ": \(superClass)"
        }
        
        return superClassPart
    }
}
