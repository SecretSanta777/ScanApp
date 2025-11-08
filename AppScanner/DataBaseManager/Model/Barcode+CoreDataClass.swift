import Foundation
import CoreData

@objc(Barcode)
public class Barcode: NSManagedObject {

}

extension Barcode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Barcode> {
        return NSFetchRequest<Barcode>(entityName: "Barcode")
    }

    @NSManaged public var name: String?
    @NSManaged public var brand: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var nutriScore: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?

}

extension Barcode : Identifiable {
    func deleteBarcode() {
        managedObjectContext?.delete(self)
        try? managedObjectContext?.save()
    }
}
