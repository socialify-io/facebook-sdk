import Foundation
import SwiftSoup

public class FacebookClient {
    
    public init() {}
    
    public func login(email: String, password: String) {
        getPayload(email: email)
    }
    
    private func getPayload(email: String) {
        let requiredInputs = ["jazoest", "lsd", "legacy_return", "trynum", "lgnrnd", "had_cp_prefilled", "had_password_prefilled"]
        
        var payload: [String: Any] = [
            "jazoest": "",
            "lsd": "",
            "display": "",
            "enable_profile_selector": "",
            "isprivate": "",
            "legacy_return": "",
            "profile_selector_ids": "",
            "return_session": "",
            "skip_api_login": "",
            "signed_next": "",
            "trynum": "",
            "timezone": "",
            "lgndim": "",
            "lgnrnd": "",
            "lgnjs": "",
            "email": email,
            "prefill_contact_point": email,
            "prefill_source": "",
            "prefill_type": "",
            "first_prefill_source": "",
            "first_prefill_type": "",
            "had_cp_prefilled": "",
            "had_password_prefilled": "",
            "ab_test_data": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/AAAAAAAAAAAA",
            "encpass": ""
        ]
        
        do {
            let content: String = try String(contentsOf: URL(string: "https://www.facebook.com/login")!)
            let doc: Document = try SwiftSoup.parseBodyFragment(content)
            
            let inputs = try doc.select("input")

            try inputs.forEach { input in
                if (requiredInputs.contains(try input.attr("name"))) {
                    payload[try input.attr("name")] = try input.attr("value")
                }
            }
            
            print(payload)
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
}
