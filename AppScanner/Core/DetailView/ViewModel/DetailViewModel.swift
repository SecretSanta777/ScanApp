//
//  DetailViewModel.swift
//  AppScanner
//
//  Created by Владимир Царь on 08.11.2025.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var shareContent: String = ""
    
    func prepareShareContent(for item: ScanItemType) {
        switch item {
        case .barcode(let barcode):
            shareContent = """
            🏷️ Штрих-код
            📦 Название: \(barcode.name ?? "Не указано")
            🏭 Бренд: \(barcode.brand ?? "Не указан")
            📋 Ингредиенты: \(barcode.ingredients ?? "Не указаны")
            ⭐ NutriScore: \(barcode.nutriScore ?? "Не указан")
            🔢 ID: \(barcode.id ?? "Не указан")
            📅 Дата: \(barcode.date ?? Date())
            """
            
        case .qrCode(let qrCode):
            shareContent = """
            🔘 QR код
            🔢 Код: \(qrCode.id ?? "Не указан")
            📅 Дата: \(qrCode.date ?? Date())
            """
        }
    }
}
