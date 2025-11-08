import Foundation

struct ScannedModel: Decodable {
    let product: Product?
}

struct Product: Decodable {
    let product_name: String?
    let brands: String?
    let ingredients_text_en: String?
    let nutriscore: Nutriscore?
}

struct Nutriscore: Decodable {
    let year2023: NutriscoreYear2023?
    
    private enum CodingKeys: String, CodingKey {
        case year2023 = "2023"
    }
}

struct NutriscoreYear2023: Decodable {
    let grade: String?
}
