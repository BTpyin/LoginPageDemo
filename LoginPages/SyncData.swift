//
//  SyncData.swift
//  LoginPages
//
//  Created by Bowie Tso on 29/4/2021.
//
import Foundation
import RealmSwift
import ObjectMapper
import FirebaseFirestore
import FirebaseCore
import Firebase

enum SyncDataFailReason: Error {
  case network
  case realmWrite
  case other
}


class SyncData {
    
    var db = Firestore.firestore()
    static var firstSync : Bool  = false
    
    static var realmBackgroundQueue = DispatchQueue(label: ".realm", qos: .background)
    
    static func writeRealmAsync(_ write: @escaping (_ realm: Realm) -> Void,
                                completed: (() -> Void)? = nil) {
      SyncData.realmBackgroundQueue.async {
        autoreleasepool {
          do {
            let realm = try Realm()
            realm.beginWrite()
            write(realm)
            try realm.commitWrite()

            if let completed = completed {
              DispatchQueue.main.async {
                let mainThreadRealm = try? Realm()
                mainThreadRealm?.refresh() // Get updateds from Background thread
                completed()
              }
            }
      } catch {
            print("writeRealmAsync Exception \(error)")
          }
        }
      }
    }
    
    func failReason(error: Error?, resposne: Any?) -> SyncDataFailReason {
      if let error = error as NSError?, error.domain == NSURLErrorDomain {
        return .network
      }
      return .other
    }
    
    
    func syncUser(completed:((SyncDataFailReason?) -> Void)?) {
        let ref = db.collection("users")
        ref.whereField("uid", isEqualTo: Auth.auth().currentUser?.uid).getDocuments{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    SyncData.writeRealmAsync({ (realm) in
                        let dict = document.data() as NSDictionary
                        realm.delete(realm.objects(Member.self))
                        realm.add(Member(JSON: document.data())!)
                        }, completed:{
                            completed?(nil)
                          })
                }
            }
        }
    }
}
