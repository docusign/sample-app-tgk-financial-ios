
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
        let file1 = ClientModel(firstName: "Triston",
                                lastName: "Gilbert",
                                address: "726 Tennessee St",
                                city: "San Francisco",
                                state: "California",
                                country: "U.S.A.",
                                zipCode: "94107",
                                email: "Triston.Gilbert@dsxtr.com",
                                phone: "510-555-1234",
                                clientNumber: "FA-45231-005",
                                investmentAmount: "$500,000.00",
                                datedDoc: "Oct 26, 2021",
                                status: "Unsigned")
        
        let file2 = ClientModel(firstName: "Andrea",
                                lastName: "Ruhn",
                                address: "221 Berkeley Drive",
                                city: "Los Angeles",
                                state: "California",
                                country: "U.S.A.",
                                zipCode: "90039",
                                email: "andrea.ruhn@digital.com",
                                phone: "213-666-1234",
                                clientNumber: "FA-43224-086",
                                investmentAmount: "$300,000.00",
                                datedDoc: "Oct 26, 2021",
                                status: "Unsigned")
        let files = [file1, file2]
        return files
    }
}
