import SwiftUI

class BarcodesViewModel: ObservableObject {
    @Published var barCodes: [Barcode] = []
    @Published var qrCodes: [QrCode] = []
        
    func fetchCodes() {
        DataBaseManager.shared.fetchBarCodes()
        DataBaseManager.shared.fetchQrCodes()
        barCodes = DataBaseManager.shared.barCodes
        qrCodes = DataBaseManager.shared.qrCodes
    }
}
