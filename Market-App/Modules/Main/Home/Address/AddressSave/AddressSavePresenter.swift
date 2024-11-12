//
//  AddressSavePresenter.swift
//  Market-App
//
//  Created by Berke Parıldar on 11.11.2024.
//

protocol AddressSavePresenterProtocol {
    func getAddressFieldCount() -> Int
    func getAddressField(at index: Int) -> AddressSaveEntity
    func getContactFieldCount() -> Int
    func getContactField(at index: Int) -> AddressSaveEntity
    func saveAddress()
    func getCurrentAddress()
}

final class AddressSavePresenter {
    unowned let view: AddressSaveViewControllerProtocol
    let interactor: AddressSaveInteractorProtocol
    let router: AddressSaveRouterProtocol
    var currentAddress: Address!
    
    let addressFields: [AddressSaveEntity] = [
        AddressSaveEntity(property: "Floor:",
                          textfieldPlaceholder: "Your floor no"),
        AddressSaveEntity(property: "Apartment No: ",
                          textfieldPlaceholder: "Your apartment no"),
        AddressSaveEntity(property: "Address Description:",
                          textfieldPlaceholder: "Near the park etc."),
        AddressSaveEntity(property: "Address Title:",
                          textfieldPlaceholder: "Home, Work etc."),
    ]
    
    let contactFields: [AddressSaveEntity] = [
        AddressSaveEntity(property: "Name:", textfieldPlaceholder: "Your name"),
        AddressSaveEntity(property: "Surname:", textfieldPlaceholder: "Your surname"),
        AddressSaveEntity(property: "Phone:", textfieldPlaceholder: "Your phone number"),
    ]
    
    init(view: AddressSaveViewControllerProtocol,
         interactor: AddressSaveInteractorProtocol,
         router: AddressSaveRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension AddressSavePresenter: AddressSavePresenterProtocol {
    func getCurrentAddress() {
        view.setCurrentAddressLabel(with: currentAddress.addressText)
    }
    
    func getAddressFieldCount() -> Int {
        return addressFields.count
    }
    
    func getAddressField(at index: Int) -> AddressSaveEntity {
        return addressFields[index]
    }
    
    func getContactFieldCount() -> Int {
        return contactFields.count
    }
    
    func getContactField(at index: Int) -> AddressSaveEntity {
        return contactFields[index]
    }
    
    func saveAddress() {
        if checkAllFields() {
            let addressText = currentAddress.addressText
            let latitude = currentAddress.latitude
            let longitude = currentAddress.longitude
            let floor = addressFields[0].value!
            let apartmentNo = addressFields[1].value!
            let addressDescription = addressFields[2].value!
            let addressTitle = addressFields[3].value!
            let name = contactFields[0].value!
            let surname = contactFields[1].value!
            let phone = contactFields[2].value!
            let newAddress = Address(addressText: addressText,
                                     latitude: latitude,
                                     longitude: longitude,
                                     floor: floor,
                                     apartmentNo: apartmentNo,
                                     description: addressDescription,
                                     title: addressTitle,
                                     contactName: name,
                                     contactSurname: surname,
                                     contactPhone: phone)
            interactor.saveAddress(address: newAddress)
        }
        else {
            view.showInfoPopUp(with: "Please fill all fields."){}
        }
    }
    
    func checkAllFields() -> Bool {
        for field in addressFields {
            if let value = field.value {
                if value.isEmpty {
                    return false
                }
            } else {
                return false
            }
        }
        
        for field in contactFields {
            if let value = field.value {
                if value.isEmpty {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
    
}

extension AddressSavePresenter: AddressSaveInteractorOutputProtocol {
    func saveAddressOutput(error: (any Error)?) {
        if let error = error {
            view.showInfoPopUp(with: "There was a problem saving the address. Please try again."){}
        }
        else {
            view.showInfoPopUp(with: "Address saved successfully.") { [weak self] in
                guard let self = self else { return }
                router.navigateToRoot()
            }
        }
    }
}

