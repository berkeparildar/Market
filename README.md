# Getir Final Case

This is a brief explanation of the important modules of Getir Lite application. The application consists of three different pages, Product Listing, Product Detail and Cart. 

## Screenshots

<img src="media/1.png" alt="Image 1" width="33%" /><img src="media/2.png" alt="Image 2" width="33%" /><img src="media/3.png" alt="Image 3" width="33%" />


## Architecture

The application is structured following the VIPER architecture.

## Modules

### ProductsAPI
This is a Swift package I've created. Its primary function is to fetch JSON data through Moya and to parse this data into a product array by decoding the JSON into DTOs which is the ProductAPI model. It includes two endpoints: one for products and another for suggested products. All fetching and decoding tasks are managed by the NetworkManager inside this package.

### Services

#### ProductService
This acts as an bridge between the ProductsAPI package and the main project. Product Service uses the NetworkManager from ProductsAPI to retrieve product information from the endpoints and converts ProductAPI models into Product models, which are used throughout the app. During this conversion, all optional values are removed to ensure that we obtain definitive Product model instances.

#### CartService
This service oversees all operations related to the shopping cart within the app. It employs DataManager to execute CoreData-related tasks and maintains an array of products that represent the cart during application runtime. CartService not only performs CRUD operations on the cart items but also updates the cart status of newly fetched products by verifying against CoreData entries. Products fetched from the internet lack cart status—defined by the 'isInCart' boolean and the 'quantityInCart' attribute—therefore, CartService updates these attributes post-fetch based on CoreData records. Notably, the CoreData retrieval is conducted during CartService's initialization to refresh the cart status of items that were in the cart during the previous session.

### CoreData

This module consists of a  CoreData stack and DataManager. The DataManager is tasked with all CoreData interactions such as fetching, inserting, deleting, or updating products. It first checks whether the product is already in the cart and, based on this, updates the quantity or handles the addition/removal of the product. If a product's quantity reaches zero, it is consequently removed from CoreData.

### Navigation Controller

In order to have the required cart button with animations, I decided that having a custom navigation controller with a custom navigation bar view would be easier. The Custom Navigation Bar is responsible for the setting title of pages, visibility of all buttons in the navigation bar, for example cart button when a product is in cart, back button when not in root controller, trash button when in Cart Page etc. Also Custom Navigation Bar displays the total cost of the cart when there are products in cart. It is worth noting that this uses Cart Service for the cart related information. Another thing to note here is the  RightNavigationButtonDelegate, which views that have the navigation bar conform to. This allows views to listen to the button taps on the navigation bar, and handle actions accordingly.

### Product Listing

 The product listing page consists of a collection view that uses compositional layout, that has two sections, one for horizontal and the other for vertical. The Product Listing's interactor uses Product Service to fetch the products from the back end, and uses Cart Service to update these fetched products' cart status. The presenter presents the data to the view, which view shows in collection view with its own custom cell, ProductCell. In order to limit the parts that use the Cart Service, I created a ProductCellDelegate for view to listen in the add or remove buttons in the ProductCell, when these buttons are tapped, the cell uses this delegate to notify the Product Listing view, which than notifies the presenter. Presenter uses Cart Service to update these changes using the interactor. The view also conforms to the RightNavigationButtonDelegate  to listen to if the user taps the cart button, if they do, router of the Product Listing is used to navigate to the Cart module of the application. This page updates it's product data each time it appears using the Cart Service.
 
### Product Detail

The detail page appears when user taps a product in the application. This Module does not fetch any data, but is passed a product model when navigating from both the product listing view and cart view. The stepper buttons at the bottom set the properties of the passed product in presenter, and is updated throught the app using the Cart Service. This way, both in product Listing and Cart page, the changes happened in the product detail is shown there as well. The only option of navigation from the product detail page is to Cart, and the view of the module listents to the tap of the cart using the RightNavigationButtonDelegate.

### Cart

The Cart Page fetches the products in the cart directly from the Cart Service, consists of a collection view that has two sections, two different custom cells and a checkout button. It uses delegates to listen button actions from these cells. The biggest difference between these cells are that the cart status of the suggested section's cells are not displayed, when a product from suggestions is added to the cart, it removes that product from the suggestions list and adds it to the cart, where user can control its quantity in the cart. Both the trash button and the checkout button show's modals, with trash button's one being dismissable. However the reason why I am mentioning these two together is becuase they both have pretty much the same effect, clearing the cart and going back to the root view.