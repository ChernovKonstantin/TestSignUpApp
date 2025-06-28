import class Foundation.NSPredicate

final class ValidationServiceImpl: ValidationService {

    func validate(_ value: String, rules: [ValidationRule.Strings]) -> ValidationResult {
        for rule in rules {
            switch rule {
            case .notEmpty:
                if value.isEmpty {
                    return .error(.empty)
                }
            case .correctEmail:
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")

                if !emailPredicate.evaluate(with: value) {
                    return .error(.notValid)
                }
            case .notShorterThan(let length):
                if value.count < length {
                    return .error(.notInRange)
                }
            case .isOptimalSize(let size):
                if size > 5 * 1024 * 1024 {
                    return .error(.notOptimalSize)
                }
            case .correctPhoneNumber:
                let digits = value.filter { $0.isNumber }
                if digits.count != 12 || !value.hasPrefix("+380") {
                    return .error(.notValid)
                }
            }
        }

        return .success
    }
}
