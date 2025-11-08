import SwiftUI

struct BarcodesView: View {
    @StateObject private var viewModel = BarcodesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // Штрих-коды
                ForEach(viewModel.barCodes, id: \.id) { barcode in
                    NavigationLink {
                        DetailScannedCodesView(item: .barcode(barcode))
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Имя: \(barcode.name ?? "")")
                            Text("Бренд: \(barcode.brand ?? "")")
                            Text("Тип: Штрих-код")
                            Text("Дата: \(barcode.date ?? Date(), style: .date)")
                        }
                        .foregroundStyle(.white)
                    }
                }
                
                // QR коды
                ForEach(viewModel.qrCodes, id: \.id) { qrCode in
                    NavigationLink {
                        DetailScannedCodesView(item: .qrCode(qrCode))
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Код: \(qrCode.id ?? "")")
                            Text("Тип: QR код")
                            Text("Дата: \(qrCode.date ?? Date(), style: .date)")
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
            .navigationTitle("Сканированные коды")
            .onAppear {
                viewModel.fetchCodes()
            }
        }
    }
}
