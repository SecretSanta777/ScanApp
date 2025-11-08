//
//  File.swift
//  AppScanner
//
//  Created by Владимир Царь on 06.11.2025.
//

import Foundation

protocol MainViewManagerProtocol {
    func fetchDataFromScan(code: String) async throws -> ScannedModel
}
