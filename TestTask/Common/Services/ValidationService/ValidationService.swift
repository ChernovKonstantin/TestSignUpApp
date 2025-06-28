enum ValidationRule {

    enum Strings {

        case notEmpty
        case correctEmail
        case correctPhoneNumber
        case notShorterThan(Int)
        case isOptimalSize(Int)
    }
}

enum ValidationError {

    case empty
    case notInRange
    case notValid
    case notOptimalSize
}

enum ValidationResult: Equatable {

    case success
    case error(ValidationError)
}

protocol ValidationService {

    func validate(_ value: String, rules: [ValidationRule.Strings]) -> ValidationResult
}
