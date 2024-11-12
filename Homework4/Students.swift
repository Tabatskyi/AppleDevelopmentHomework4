import Foundation
import UIKit

struct Address: Codable {
    let street: String?
    let city: String?
    let postalCode: String?

}

class Student: Codable {
    let id: Int
    let name: String
    let age: Int?
    let subjects: [String]?
    let address: Address?
    let scores: [String: Int?]?
    let hasScholarship: Bool?
    let graduationYear: Int?

    func average() -> Double {
        let scores = self.scores ?? ["": nil]
        let marks = scores.values.map { $0 ?? 0 }
        let sum = marks.reduce(0, +)
        return Double(sum) / Double(marks.count)
    }
}

struct Students: Codable {
    var students: [Student]
}

class ModelParser {
    let students: [Student]

    enum NotFoundError: Error {
        case runtimeError(String)
    }
    // https://stackoverflow.com/questions/33351108/get-data-from-xcasset-catalog
    init(name: String) throws {
        guard let asset = NSDataAsset(name: name) else {
            throw NotFoundError.runtimeError("Not found asset")
        }
        let data = asset.data
        students = try JSONDecoder().decode(Students.self, from: data).students
    }

    func getStudents() -> [Student] {
        return students
        }
    }
