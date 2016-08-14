//
//  UnboxedAlamofire.swift
//  UnboxedAlamofire
//
//  Created by Serhii Butenko on 26/7/16.
//  Copyright © 2016 Serhii Butenko. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

// MARK: - Requests

extension Request {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by Unbox.
     
     - returns: The request.
     */
    public func responseObject<T: Unboxable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: Response<T, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.UnboxObjectSerializer(options, keyPath: keyPath), completionHandler: completionHandler)
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by Unbox.
     
     - returns: The request.
     */
    public func responseArray<T: Unboxable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.UnboxArraySerializer(options, keyPath: keyPath), completionHandler: completionHandler)
    }
}

// MARK: - Serializers

private extension Request {
    
    static func UnboxObjectSerializer<T: Unboxable>(options: NSJSONReadingOptions, keyPath: String?) -> ResponseSerializer<T, NSError>  {
        return ResponseSerializer { request, response, data, error in
            if let error = error {
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            let jsonCandidate: AnyObject?
            if let keyPath = keyPath where !keyPath.isEmpty {
                jsonCandidate = result.value?.valueForKeyPath(keyPath)
            } else {
                jsonCandidate = result.value
            }
            
            guard let json = jsonCandidate as? UnboxableDictionary else {
                return .Failure(UnboxError.InvalidData as NSError)
            }
            
            do {
                return .Success(try Unbox(json))
            } catch let unboxError as UnboxError {
                return .Failure(NSError(domain: "UnboxError", code: unboxError._code, userInfo: [NSLocalizedDescriptionKey: unboxError.description]))
            } catch let error as NSError {
                return .Failure(error)
            }
        }
    }
    
    static func UnboxArraySerializer<T: Unboxable>(options: NSJSONReadingOptions, keyPath: String?) -> ResponseSerializer<[T], NSError> {
        return ResponseSerializer { request, response, data, error in
            if let error = error {
                return .Failure(error)
            }

            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            let jsonCandidate: AnyObject?
            if let keyPath = keyPath where !keyPath.isEmpty {
                jsonCandidate = result.value?.valueForKeyPath(keyPath)
            } else {
                jsonCandidate = result.value
            }
            
            guard let json = jsonCandidate as? [UnboxableDictionary] else {
                return .Failure(UnboxError.InvalidData as NSError)
            }
            
            do {
                return .Success(try map(json))
            } catch let unboxError as UnboxError {
                return .Failure(NSError(domain: "UnboxError", code: unboxError._code, userInfo: [NSLocalizedDescriptionKey: unboxError.description]))
            } catch let error as NSError {
                return .Failure(error)
            }
        }
    }
}

// MARK: - Helpers

private func map<T: Unboxable>(objects: [UnboxableDictionary]) throws -> [T] {
    
    return try objects.reduce([T](), combine: { container, rawValue in
        let value = try Unbox(rawValue) as T
        return container + [value]
    })
}
