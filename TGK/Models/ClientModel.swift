
import Foundation

struct ClientModel {
    var firstName: String?
    var lastName: String?
    var address: String?
    var city: String?
    var state: String?
    var country: String?
    var zipCode: String?
    var email: String?
    var phone: String?
    var clientNumber: String?
    var investmentAmount: String?
    var datedDoc: String?
    var status: String?
}

struct Clients {
    func createdFakeClientData() -> [ClientModel] {
        let file1 = ClientModel(firstName: "Tom",
                                lastName: "Wood",
                                address: "726 Tennessee St",
                                city: "San Francisco",
                                state: "California",
                                country: "U.S.A.",
                                zipCode: "94107",
                                email: "tom.wood@digital.com",
                                phone: "415-555-1234",
                                clientNumber: "FA-45231-005",
                                investmentAmount: "$25,000.00",
                                datedDoc: "June 20, 2019",
                                status: "Unsigned")
        
        let file2 = ClientModel(firstName: "Andrea",
                                lastName: "Ruhn",
                                address: "726 Tennessee St",
                                city: "Los Angeles",
                                state: "California",
                                country: "U.S.A.",
                                zipCode: "70707",
                                email: "andrea.ruhn@digital.com",
                                phone: "555-666-1234",
                                clientNumber: "FA-43224-086",
                                investmentAmount: "$300,000.00",
                                datedDoc: "May 18, 2020",
                                status: "Unsigned")
        let files = [file1, file2]
        return files
    }
}
