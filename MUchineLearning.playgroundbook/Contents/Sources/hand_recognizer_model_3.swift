//
// hand_recognizer_model_3.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class hand_recognizer_model_3Input : MLFeatureProvider {
    
    /// data as color (kCVPixelFormatType_32BGRA) image buffer, 227 pixels wide by 227 pixels high
    public var data: CVPixelBuffer
    
    public var featureNames: Set<String> {
        get {
            return ["data"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "data") {
            return MLFeatureValue(pixelBuffer: data)
        }
        return nil
    }
    
    public init(data: CVPixelBuffer) {
        self.data = data
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class hand_recognizer_model_3Output : MLFeatureProvider {
    
    /// loss as dictionary of strings to doubles
    public let loss: [String : Double]
    
    /// classLabel as string value
    public let classLabel: String
    
    public var featureNames: Set<String> {
        get {
            return ["loss", "classLabel"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "loss") {
            return try! MLFeatureValue(dictionary: loss as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    public init(loss: [String : Double], classLabel: String) {
        self.loss = loss
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class hand_recognizer_model_3 {
    public var model: MLModel
    
    /**
     Construct a model with explicit path to mlmodel file
     - parameters:
     - url: the file url of the model
     - throws: an NSError object that describes the problem
     */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }
    
    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: hand_recognizer_model_3.self)
        let assetPath = bundle.url(forResource: "hand_recognizer_model_3", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }
    
    /**
     Make a prediction using the structured interface
     - parameters:
     - input: the input to the prediction as hand_recognizer_model_3Input
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as hand_recognizer_model_3Output
     */
    public func prediction(input: hand_recognizer_model_3Input) throws -> hand_recognizer_model_3Output {
        let outFeatures = try model.prediction(from: input)
        let result = hand_recognizer_model_3Output(loss: outFeatures.featureValue(for: "loss")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }
    
    /**
     Make a prediction using the convenience interface
     - parameters:
     - data as color (kCVPixelFormatType_32BGRA) image buffer, 227 pixels wide by 227 pixels high
     - throws: an NSError object that describes the problem
     - returns: the result of the prediction as hand_recognizer_model_3Output
     */
    public func prediction(data: CVPixelBuffer) throws -> hand_recognizer_model_3Output {
        let input_ = hand_recognizer_model_3Input(data: data)
        return try self.prediction(input: input_)
    }
}
