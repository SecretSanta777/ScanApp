import SwiftUI
import AVFoundation

struct MainView: View {
    
    @StateObject var mainViewModel: MainViewModel = .init()
    
    @State var showCamera: Bool = false
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Text("Нажмите на знакочк qr-code, чтобы начать сканировать")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.gray)
            
            Spacer()
            
            if showCamera {
                CameraView(session: $mainViewModel.session)
                    .frame(width: 300, height: 300)
                    .cornerRadius(15)
                    .onDisappear {
                        mainViewModel.session.stopRunning()
                    }
                
                Button {
                    withAnimation {
                        mainViewModel.haveTorch()
                    }
                } label: {
                    Image(systemName: "flashlight.on.fill")
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    showCamera = true
                    if !mainViewModel.session.isRunning && mainViewModel.cameraPermission == .approved {
                        mainViewModel.reactivateCamera()
                    }
                }
            } label: {
                Image(systemName: "qrcode")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .background(.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(.white)
        .onAppear(perform: mainViewModel.cheackCameraPermission)
        .onDisappear {
            showCamera = false
        }
        .alert(mainViewModel.errosMessage, isPresented: $mainViewModel.showError) {
            if mainViewModel.cameraPermission == .denied {
                Button("Settings") {
                    let settings = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settings) {
                        withAnimation {
                            openURL(settingsURL)
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) {
                    
                }
            }
        }
    }
}

#Preview {
    MainView()
}
