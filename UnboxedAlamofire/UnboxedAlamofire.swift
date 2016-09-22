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

extension DataRequest {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by Unbox.
     
     - returns: The request.
     */
    @discardableResult
    public func responseObject<T: Unboxable>(queue: DispatchQueue? = nil, keyPath: String? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.UnboxObjectSerializer(options, keyPath: keyPath), completionHandler: completionHandler)
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed.
     - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by Unbox.
     
     - returns: The request.
     */
    @discardableResult
    public func responseArray<T: Unboxable>(queue: DispatchQueue? = nil, keyPath: String? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.UnboxArraySerializer(options, keyPath: keyPath), completionHandler: completionHandler)
    }
    
//(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperSerializer(keyPath, mapToObject: object, context: context), completionHandler: completionHandler)
//    }
}

// MARK: - Serializers

private extension Request {
    
    static func UnboxObjectSerializer<T: Unboxable>(_ options: JSONSerialization.ReadingOptions, keyPath: String?) -> DataResponseSerializer<T>  {
        return DataResponseSerializer { request, response, data, error in
            if let error = error {
                return .failure(error)
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            let jsonCandidate: Any?
            if let keyPath = keyPath , !keyPath.isEmpty {
                jsonCandidate = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
            } else {
                jsonCandidate = result.value
            }
            
            guard let json = jsonCandidate as? UnboxableDictionary else {
                return .failure(UnboxError.InvalidData as NSError)
            }
            
            do {
                return .success(try Unbox(dictionary: json))
            } catch let unboxError as UnboxError {
                return .failure(NSError(domain: "UnboxError", code: unboxError._code, userInfo: [NSLocalizedDescriptionKey: unboxError.description]))
            } catch let error as NSError {
                return .failure(error)
            }
        }
    }
    
    static func UnboxArraySerializer<T: Unboxable>(_ options: JSONSerialization.ReadingOptions, keyPath: String?) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            if let error = error {
                return .failure(error)
            }

            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            let jsonCandidate: Any?
            if let keyPath = keyPath , !keyPath.isEmpty {
                jsonCandidate = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
            } else {
                jsonCandidate = result.value
            }
            
            guard let json = jsonCandidate as? [UnboxableDictionary] else {
                return .failure(UnboxError.InvalidData as NSError)
            }
            
            do {
                return .success(try map(json))
            } catch let unboxError as UnboxError {
                return .failure(NSError(domain: "UnboxError", code: unboxError._code, userInfo: [NSLocalizedDescriptionKey: unboxError.description]))
            } catch let error as NSError {
                return .failure(error)
            }
        }
    }
}

// MARK: - Helpers

private func map<T: Unboxable>(_ objects: [UnboxableDictionary]) throws -> [T] {
    
    return try objects.reduce([T](), { container, rawValue in
        let value = try Unbox(dictionary: rawValue) as T
        return container + [value]
    })
}
