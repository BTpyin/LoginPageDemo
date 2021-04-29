//
//  Member.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//
import Foundation
import RealmSwift
import ObjectMapper

class Member: Object, Mappable{
    @objc dynamic var memberName : String?
    @objc dynamic var phone : String?
    @objc dynamic var email : String?
    @objc dynamic var memberNumber : String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        memberName <- map["memberName"]
        email <- map["email"]
        phone <- map["phone"]
        memberNumber <- map["memId"]
    }
    
    func demoMember()-> Member{
        var demo = Member()
        demo.memberName = "Test Name"
        demo.email = "demo@demo.com"
        demo.phone = "60265050"
        demo.memberNumber = "12345678"
        return demo
    }
    
}
