//
//  FirebaseUserService.swift
//  MarketFirebaseService
//
//  Created by Berke Parıldar on 12.11.2024.
//

import FirebaseFirestore

public class FirebaseUserService {
    
    private let db = Firestore.firestore()
    
    public init() {}
        
    private let documentError = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "Document not found."])
    
    public func fetchUserData(uid: String,
                              completion: @escaping (Result<[String: Any], Error>) -> Void) {

        db.collection("users").document(uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                var userData = document.data()!
                if var addresses = userData["addresses"] as? [[String: Any]] {
                    for i in 0..<addresses.count {
                        var address = addresses[i]
                        
                        if let geoPoint = address["geoPoint"] as? GeoPoint {
                            address["latitude"] = geoPoint.latitude
                            address["longitude"] = geoPoint.longitude
                        }
                        
                        addresses[i] = address
                    }
                    
                    userData["addresses"] = addresses
                }
                completion(.success(userData))
            } else {
                completion(.failure(documentError))
            }
        }
    }
    
    public func updateUserAddress(uid: String,
                                  addressData: [[String: Any?]],
                                  completion: @escaping (Error?) -> Void) {

        var geoAddresses = addressData.map { address in
            return [
                "addressText": address["addressText"] as? String ?? "",
                "geoPoint": GeoPoint(latitude: address["latitude"] as? Double ?? 0,
                                        longitude: address["longitude"] as? Double ?? 0),
                "floor": address["floor"] as? String ?? "",
                "apartmentNo": address["apartmentNo"] as? String ?? "",
                "description": address["description"] as? String ?? "",
                "title": address["title"] as? String ?? "",
                "contactName": address["contactName"] as? String ?? "",
                "contactSurname": address["contactSurname"] as? String ?? "",
                "contactPhone": address["contactPhone"] as? String ?? "",
            ]
        }
        
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData(["addresses": geoAddresses]) { error in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User data successfully updated.")
                completion(nil)
            }
        }
    }
    
    public func updateUserData(uid: String,
                               userData: [String: Any?],
                               completion: @escaping (Error?) -> Void) {

        let userRef = db.collection("users").document(uid)
        
        let filteredUserData = userData.compactMapValues { $0 }
        
        userRef.updateData(filteredUserData) { error in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User data updated successfully")
                completion(nil)
            }
        }
    }
}
