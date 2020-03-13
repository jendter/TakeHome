//
//  API.swift
//  TakeHome
//
//  Created by Joshua Endter on 2020-03-11.
//  Copyright © 2020 JRE. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum APICall {
    case categories
    case ads(categoryId: Int)
}

extension APICall: TargetType {
    var baseURL: URL {
        return URL(string: "https://ios-interview.surge.sh")!
    }
    
    var path: String {
        switch self {
        case .categories:
            return "/categories"
        case .ads(let categoryId):
            return "/categories/\(categoryId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data("".utf8)
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

extension MoyaProvider {
    static func standardProvider(timeout: TimeInterval) -> MoyaProvider<Target> {
        let plugins = Env.isDebug ? [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))] : []
        let session: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            configuration.timeoutIntervalForRequest = timeout
            configuration.timeoutIntervalForResource = timeout
            return Session(configuration: configuration, startRequestsImmediately: false)
        }()
        return MoyaProvider<Target>.init(session: session, plugins: plugins)
    }
}

extension MoyaError {
    private var kCheckNetworkConnection: String { "Please check your connection to the internet." }
    
    var networkLocalizedDescription: String {
        // Return user-friendly message if error is network related.
        let nsError = (self as NSError)
        switch nsError.domain {
        case NSURLErrorDomain:
            switch nsError.code {
            case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet: return kCheckNetworkConnection
            default: break
            }
        case NSPOSIXErrorDomain:
            switch nsError.code {
            case 50: return kCheckNetworkConnection
            default: break
            }
        default: break
        }
        
        return localizedDescription
    }
}
