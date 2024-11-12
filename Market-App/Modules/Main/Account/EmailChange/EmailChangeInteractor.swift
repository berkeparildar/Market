//
//  EmailChanceInteractor.swift
//  Market-App
//
//  Created by Berke Parıldar on 9.11.2024.
//

protocol EmailChangeInteractorProtocol: AnyObject {
    func getEmail()
    func updateEmail(email: String)
    func getEmailVerifiedStatus()
}

protocol EmailChangeInteractorOutputProtocol: AnyObject {
    func getEmailOutput(result: String)
    func updateEmailOutput(error: Error?)
    func getEmailVerifiedStatusOutput(result: Bool)
}

final class EmailChangeInteractor {
    var output: EmailChangeInteractorOutputProtocol?
}

extension EmailChangeInteractor: EmailChangeInteractorProtocol {
    func getEmailVerifiedStatus() {
        let verifiedEmail = UserService.shared.currentUser!.verifiedEmail
        output?.getEmailVerifiedStatusOutput(result: verifiedEmail)
    }
    
    func updateEmail(email: String) {
        UserService.shared.updateUserEmail(newMail: email) { [weak self] error in
            guard let self = self else { return }
            output?.updateEmailOutput(error: error)
        }
    }
    
    func getEmail() {
        output?.getEmailOutput(result: UserService.shared.currentUser!.email)
    }
}
