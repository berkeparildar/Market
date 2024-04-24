//
//  ProductServiceTest.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation

import XCTest
@testable import Getir_Final_Case
@testable import ProductsAPI

final class ProductServiceTest: XCTestCase {
    
    var productService: ProductService!
    override func setUp() {
        super.setUp()
        productService = ProductService()
    }
    
    override func tearDown() {
        super.tearDown()
        productService = nil
    }
    
    func test_buildProducts() {
        let generatedProduct = Product(id: "5d6d2c696deb8b00011f7665", productName: "Kuzeyden", productDescription: "2 x 5 L", productPrice: 59.2, productPriceText: "59.2", isInCart: false, quantityInCart: 0, imageURL: URL(string: "http://cdn.getir.com/product/5d6d2c696deb8b00011f7665_tr_1617795578982.jpeg")!)
        let apiProducts = NetworkProductResponse.productAPIResponse
        let builtProducts = productService.buildProducts(apiProducts: apiProducts)
        XCTAssertEqual(generatedProduct.id, builtProducts[0].id)
        XCTAssertEqual(generatedProduct.productName, builtProducts[0].productName)
        XCTAssertEqual(generatedProduct.productPrice, builtProducts[0].productPrice)
        XCTAssertEqual(generatedProduct.imageURL, builtProducts[0].imageURL)
        XCTAssertEqual(generatedProduct.productDescription, builtProducts[0].productDescription)
    }

}

extension NetworkProductResponse {
    static var productAPIResponse: [ProductAPI] {
        let bundle = Bundle(for: ProductListingPresenterTests.self)
        let path = bundle.path(forResource: "SingleProduct", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)
        let productResponse = try! JSONDecoder().decode([NetworkProductResponse].self, from: data!)
        return productResponse.first!.results
    }
}
