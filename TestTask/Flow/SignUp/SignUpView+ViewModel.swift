import SwiftUI
import Combine

extension SignUpView {
    final class SignUpViewModel: ObservableObject {
        private let diContainer: DIContainer
        private var cancelBag = Set<AnyCancellable>()
        
        @Published var name: String = ""
        @Published var nameError: String = ""
        @Published var email: String = ""
        @Published var emailError: String = ""
        @Published var phone: String = ""
        @Published var phoneError: String = ""
        @Published var positionID: Int = 0
        @Published var positions: [Position]?
        @Published var photo: UIImage?
        @Published var photoText: String = ""
        @Published var photoError: String = ""
        @Published var isLoading: Bool = false
        @Published var canSignUp: Bool = false
        @Published var userCreationSuccess: Bool? = nil
        @Published var userCreationError: String? = nil
        
        init(diContainer: DIContainer) {
            self.diContainer = diContainer
            
            setupBindings()
            loadPositions()
        }
        
        private func loadPositions() {
            Task {
                do {
                    let positions = try await diContainer.services.usersService.getPositions()
                    await MainActor.run { [weak self] in
                        self?.positionID = positions.first?.id ?? 1
                        self?.positions = positions
                    }
                } catch {
                    print(error.localizedDescription)
                    await MainActor.run { [weak self] in
                        self?.positions = []
                    }
                }
            }
        }
        
        private func setupBindings() {
            $name
                .drop(while: { $0.isEmpty })
                .removeDuplicates()
                .map { [weak self] in self?.nameValidationError($0) ?? "" }
                .assignWeak(to: \.nameError, on: self)
                .store(in: &cancelBag)
            
            $email
                .drop(while: { $0.isEmpty })
                .removeDuplicates()
                .map { [weak self] in self?.emailValidationError($0) ?? "" }
                .assignWeak(to: \.emailError, on: self)
                .store(in: &cancelBag)
            
            $phone
                .drop(while: { $0.isEmpty })
                .removeDuplicates()
                .map { [weak self] in self?.phoneValidationError($0) ?? "" }
                .assignWeak(to: \.phoneError, on: self)
                .store(in: &cancelBag)
            
            $photo
                .drop(while: { $0 == nil })
                .removeDuplicates()
                .sink { [weak self] newImage in
                    self?.photoText = "Photo uploaded"
                }
                .store(in: &cancelBag)
            
            $photo
                .drop(while: { $0 == nil })
                .removeDuplicates()
                .map { [weak self] in self?.photoValidationError($0) ?? "" }
                .assignWeak(to: \.photoError, on: self)
                .store(in: &cancelBag)
            
            Publishers.CombineLatest4($email, $name, $phone, $photo)
                .dropFirst()
                .map { [weak self] in
                    guard let self else { return false }
                    let noErrors = self.nameError.isEmpty && self.emailError.isEmpty && self.photoError.isEmpty && self.phoneError.isEmpty
                    let noEmpties = !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && $3 != nil
                    return noErrors && noEmpties
                }
                .assignWeak(to: \.canSignUp, on: self)
                .store(in: &cancelBag)

            
        }
        
        private func nameValidationError(_ name: String) -> String? {
            if case let .error(error) = diContainer.services.validationService.validate(name, rules: [.notEmpty, .notShorterThan(2)]) {
                switch error {
                case .empty:
                    return "Required field"
                case .notInRange:
                    return "The name must be at least 2 characters."
                default: break
                }
            }
            
            return nil
        }
        
        private func emailValidationError(_ email: String) -> String? {
            if case let .error(error) = diContainer.services.validationService.validate(email, rules: [.notEmpty, .correctEmail]) {
                switch error {
                case .empty:
                    return "Required field"
                case .notValid:
                    return "The email must be a valid email address."
                default: break
                }
            }
            
            return nil
        }
        
        private func phoneValidationError(_ phone: String) -> String? {
            if case let .error(error) = diContainer.services.validationService.validate(phone, rules: [.notEmpty, .correctPhoneNumber]) {
                switch error {
                case .empty:
                    return "Required field"
                case .notValid:
                    return "The phone field is required."
                default: break
                }
            }
            
            return nil
        }
        
        private func photoValidationError(_ photo: UIImage?) -> String? {
            if let photoData = photo?.jpegData(compressionQuality: 0.7),
               case let .error(error) = diContainer.services.validationService.validate("", rules: [.isOptimalSize(photoData.count)]) {
                switch error {
                case .empty:
                    return "Photo is required"
                case .notOptimalSize:
                    return "The photo may not be greater than 5 Mbytes."
                default: break
                }
            }
            
            return nil
        }
        
        func resetInputs() {
            name = ""
            email = ""
            phone = ""
            photo = nil
            nameError = ""
            emailError = ""
            phoneError = ""
            photoError = ""
            photoText = ""
            userCreationError = nil
            userCreationSuccess = nil
            photo = nil
            isLoading = false
            canSignUp = false
        }
        
        func signUpTap() {
            guard nameError.isEmpty, emailError.isEmpty, phoneError.isEmpty, photoError.isEmpty,
            let photoData = photo?.jpegData(compressionQuality: 0.7) else {
                canSignUp = false
                return
            }
            
            isLoading = true
            Task {
                do {
                    let user = NewUser(name: name, email: email, phone: phone, positionId: positionID, photo: photoData)
                    let result = try await diContainer.services.usersService.createUser(user: user)
                    await MainActor.run { [weak self] in
                        self?.userCreationSuccess = result
                        self?.isLoading = false
                    }
                } catch {
                    print(error.localizedDescription)
                    await MainActor.run { [weak self] in
                        print(error.localizedDescription)
                        if let error = error as? NetworkError, case .validationError(let dictionary) = error {
                            dictionary.forEach { key, value in
                                let error = value.joined(separator: ", ")
                                switch key {
                                case "name":
                                    self?.nameError = error
                                case "email":
                                    self?.emailError = error
                                case "phone":
                                    self?.phoneError = error
                                case "photo":
                                    self?.photoError = error
                                default:
                                    self?.userCreationError = error
                                }
                            }
                        } else {
                            self?.userCreationError = error.localizedDescription
                            self?.userCreationSuccess = false
                        }
                        self?.isLoading = false
                    }
                }
            }
        }
    }
}
