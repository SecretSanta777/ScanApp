import Foundation

class MainViewManager: MainViewManagerProtocol {
    func fetchDataFromScan(code: String) async throws -> ScannedModel {
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(code).json") else { throw ErrorType.invalidURL }
        
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        guard let httpsResonce = responce as? HTTPURLResponse, httpsResonce.statusCode == 200 else { throw ErrorType.badServerResponce }
        print(httpsResonce.statusCode)
        
        do {
            let result = try JSONDecoder().decode(ScannedModel.self, from: data)
            return result
        } catch {
            throw ErrorType.decodingFailed
        }
    }
}

