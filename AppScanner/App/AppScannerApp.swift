import SwiftUI

@main
struct AppScannerApp: App {
    
    @State var appRoute: AppRoute = .main
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $appRoute) {
                MainView()
                    .tag(AppRoute.main)
                    .tabItem {
                        Image(systemName: appRoute == .main ? "house.fill" : "house")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                
                BarcodesView()
                    .tag(AppRoute.barcodes)
                    .tabItem {
                        Image(systemName: appRoute == .barcodes ? "barcode" : "qrcode")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                
                
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

