import Foundation
import RealmSwift

class PostDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var userName: String = ""
    @objc dynamic var postText: String = ""
}
