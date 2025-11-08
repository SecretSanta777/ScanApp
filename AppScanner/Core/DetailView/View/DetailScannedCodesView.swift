import SwiftUI

struct DetailScannedCodesView: View {
    var item: ScanItemType
    @StateObject private var viewModel = DetailViewModel()
    @State private var showShareSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch item {
            case .barcode(let barcode):
                Text("Штрих-код")
                    .font(.title)
                    .bold()
                
                Group {
                    Text("Название: \(barcode.name ?? "Не указано")")
                    Text("Бренд: \(barcode.brand ?? "Не указан")")
                    Text("Ингредиенты: \(barcode.ingredients ?? "Не указаны")")
                    Text("NutriScore: \(barcode.nutriScore ?? "Не указан")")
                    Text("ID: \(barcode.id ?? "Не указан")")
                    Text("Дата: \(barcode.date ?? Date())")
                }
                .font(.body)
                
            case .qrCode(let qrCode):
                Text("QR код")
                    .font(.title)
                    .bold()
                
                Group {
                    Text("Код: \(qrCode.id ?? "Не указан")")
                    Text("Дата: \(qrCode.date ?? Date())")
                }
                .font(.body)
            }
            
            Spacer()
            
            // Кнопка поделиться
            Button {
                viewModel.prepareShareContent(for: item)
                showShareSheet = true
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Поделиться")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Детали")
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [viewModel.shareContent])
        }
    }
}


#Preview {
    NavigationView {
        DetailScannedCodesView(item: .qrCode(QrCode()))
    }
}
