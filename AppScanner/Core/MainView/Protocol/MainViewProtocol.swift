import Foundation

protocol MainViewManagerProtocol {
    func fetchDataFromScan(code: String) async throws -> ScannedModel
}
