//
//  CartServiceTest.swift
//  Getir-Final-CaseTests
//
//  Created by Berke Parıldar on 24.04.2024.
//

import Foundation

import XCTest
@testable import Getir_Final_Case

final class CartServiceTest: XCTestCase {
    
    var mockProduct: Product!
    var cartService: CartService!
    
    override func setUp() {
        super.setUp()
        cartService = CartService()
        mockProduct = Product(id: "63e642b6d98e4949555fde1d", productName: "Coca-Cola & Fanta & Sprite Trio", productDescription: "Description", productPrice: 0.0, productPriceText: "0.0", isInCart: true, quantityInCart: 1, imageURL: URL(string: "https://market-product-images-cdn.getirapi.com/product/76cec514-00b9-4586-801a-fb5e641fb446.png")!)
    }
    
    override func tearDown() {
        super.tearDown()
        mockProduct = nil
        cartService = nil
    }
    
    func test_addProductToCart() {
        cartService.clearProductsInCart() // no products in cart
        XCTAssertTrue(cartService.isCartEmpty())
        cartService.addProductToCart(product: mockProduct)
        XCTAssertFalse(cartService.isCartEmpty())
        let productsInCart = cartService.getProductsInCart()
        XCTAssertEqual(mockProduct, productsInCart[0])
    }
    
    func test_removeProductFromCart() {
        cartService.clearProductsInCart() // no products in cart
        cartService.addProductToCart(product: mockProduct)
        let productsInCart = cartService.getProductsInCart()
        XCTAssertEqual(mockProduct, productsInCart[0])
        cartService.removeProductFromCart(product: mockProduct)
        XCTAssertTrue(cartService.isCartEmpty())
    }
    
    func test_getProductsInCart() {
        cartService.clearProductsInCart() // no products in cart
        cartService.addProductToCart(product: mockProduct)
        let productsInCart = cartService.getProductsInCart()
        XCTAssertEqual(mockProduct, productsInCart[0])
    }
    
    func test_getProductFromCartWithID() {
        cartService.clearProductsInCart() // no products in cart
        cartService.addProductToCart(product: mockProduct)
        let productID = mockProduct.id
        let productFromCart = cartService.getProductFromCartWithID(id: productID)
        XCTAssertEqual(productFromCart, mockProduct)
    }
}
