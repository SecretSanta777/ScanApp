//
//  ErrorType.swift
//  AppScanner
//
//  Created by Владимир Царь on 08.11.2025.
//
import Foundation

enum ErrorType: Error {
    case invalidURL
    case badServerResponce
    case decodingFailed
}
