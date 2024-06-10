# Market

Market is an iOS application designed to transform your phone into a convenient marketplace. The app allows users to browse and purchase products easily through a user-friendly interface featuring categorized product listings, a dynamic cart system, and personalized product suggestions.

**ASP.NET Core Server Repository:** [https://github.com/berkeparildar/Market-Server]

## Screenshots
<img src="Media/1.png" alt="Image 1" width="33%" /><img src="Media/2.png" alt="Image 2" width="33%" /><img src="Media/3.png" alt="Image 3" width="33%" />

### Features
- User Interface: The app opens to a Products Page with a horizontally scrollable category bar at the top and a vertically scrollable product list below, allowing users to easily navigate between different product categories.
- Adding to Cart: Users can add products to their cart by tapping the "+" button on the product, which then opens a stepper to adjust the quantity. The cart button in the upper right corner shows the total amount in the cart.
- Detailed Product View: Tapping on a product opens a detailed view where users can add or remove the product from their cart and adjust its quantity.
- Cart Management: Users can access the cart by tapping the cart button in the navigation bar. The cart page displays all added products with steppers to control their quantity, an empty cart button to clear all items, and a horizontally scrollable list of suggested products based on the categories of items in the cart.
- Suggested Products: Suggested products appear below the cart items and can be added to the cart by tapping the "+" sign.
- Order Completion: A button below the suggested products allows users to complete their order. Upon completion, users receive a success notification with the total amount and are automatically navigated back to the Products Page.
- Data Persistence: Core Data integration ensures that products added to the cart are saved locally, allowing users to retain their cart items even if they quit the app.

### How to Use
- Navigate Categories: Open the app to the Products Page and use the horizontally scrollable category bar to browse through different product categories.
- Add Products to Cart: Tap the "+" button on any product to add it to the cart. Use the stepper to adjust the quantity. The cart button will display the current total amount in the cart.
- View Product Details: Tap on any product to see more details. From the detailed view, adjust the product quantity or add/remove it from the cart.
- Manage Cart: Tap the cart button in the navigation bar to view all items in your cart. Adjust quantities using the steppers, or use the empty cart button to remove all items.
- Add Suggested Products: Scroll through the suggested products list below the cart items and tap the "+" sign to add any suggested item to the cart.
- Complete Order: Tap the "Complete Order" button to finalize your purchase. A success notification with the total amount will appear, and you will be navigated back to the Products Page.
- Persistent Cart: Rest assured that your cart items are saved locally with Core Data, so you can continue shopping even after closing and reopening the app.