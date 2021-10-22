

struct AccessTokenResponse: Codable {
    let accessToken: String
}

struct UserInfoResponse: Codable {
    let sub: String
    let email: String
    let accounts: [AccountInfo]
}

struct AccountInfo: Codable {
    let accountId: String
    let accountName: String
}

struct EnvelopeInfo: Codable {
    let envelopeId: String
    let uri: String
    let statusDateTime: String
    let status: String
}
