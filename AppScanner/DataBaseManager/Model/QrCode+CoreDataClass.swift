import Foundation
import CoreData

@objc(QrCode)
public class QrCode: NSManagedObject {

}

extension QrCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QrCode> {
        return NSFetchRequest<QrCode>(entityName: "QrCode")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date?

}

extension QrCode : Identifiable {

}
