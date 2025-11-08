//
//  MainViewModel.swift
//  AppScanner
//
//  Created by Владимир Царь on 06.11.2025.
//

import SwiftUI
import AVFoundation

class MainViewModel: NSObject, ObservableObject {
    
    //Код, который отсканили
    @Published var scannedCode: String? = ""
    
    //Модель для декодирования запроса
    @Published var barCode: [ScannedModel] = []
    
    //Сессия камеры
    @Published var session: AVCaptureSession = .init()
    
    // АутПут (что возвращаем при скане)
    private var qrOutput: AVCaptureMetadataOutput = .init()
    
    //Тип разрешение пользования камерой
    @Published var cameraPermission: Permission = .idle
    
    //Обработка ошибок
    @Published var errosMessage: String = ""
    @Published var showError: Bool = false
    
    //Тип скана
    @Published var scannedCodeType: String = ""
    
    //Инстенс нетворк менеджера
    var networkManager: MainViewManagerProtocol = MainViewManager()
    
    //Проверка доступа к камере
    @MainActor
    func cheackCameraPermission() {
        print(FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0])
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    reactivateCamera()
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    
                    presentError("Please Provide Access to Camera for scaninng codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera for scaninng codes")
            default:
                break
            }
        }
    }
    
    //Настриваем камеру
    func setupCamera() {
        
        if session.isRunning {
            session.stopRunning()
        }
        
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }
        
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN ERROR")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            guard session.canAddInput(input) else {
                presentError("Cannot add input")
                return
            }
            
            guard session.canAddOutput(qrOutput) else {
                presentError("Cannot add output")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            qrOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .upce, .code39, .code128, .pdf417, .aztec]
            qrOutput.setMetadataObjectsDelegate(self, queue: .main)
            session.commitConfiguration()
            
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    //обработчик ошибок
    func presentError(_ message: String) {
        errosMessage = message
        showError.toggle()
    }
    
    //Фонарик
    func haveTorch() {
        let device = AVCaptureDevice.default(for: .video)
        do {
            try device?.lockForConfiguration()
            device?.torchMode = device?.torchMode == .on ? .off : .on
            device?.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Получаем данные от апи и сохраняем в кордату
    func fetchDataFromScaned() async {
        do {
            let result = try await networkManager.fetchDataFromScan(code: scannedCode ?? "")
            
            if scannedCodeType == "QR Code" {
                DataBaseManager.shared.createQrCode(id: scannedCode ?? "")
                print(1)
            } else {
                DataBaseManager.shared.createBarcode(
                    name: result.product?.product_name ?? "",
                    ingredients: result.product?.ingredients_text_en ?? "",
                    brand: result.product?.brands ?? "",
                    nutriScore: result.product?.nutriscore?.year2023?.grade ?? "",
                    id: scannedCode ?? ""
                )
                print(2)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Запуск камеры
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
    
    //Возвращаем тип скана
    func getCodeTypeName(_ type: AVMetadataObject.ObjectType) -> String {
        switch type {
        case .qr: return "QR Code"
        case .ean8: return "EAN-8"
        case .ean13: return "EAN-13"
        case .upce: return "UPC-E"
        case .code39: return "Code 39"
        case .code128: return "Code 128"
        case .pdf417: return "PDF417"
        case .aztec: return "Aztec"
        default: return "Unknown"
        }
    }
    
}

