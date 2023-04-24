//
//  TextRecognitionTypes.swift
//  TextRecognition
//
//  Created by Joey Eamigh on 4/24/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import NaturalLanguage
import Vision

extension String {
  func stripPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

enum RecognitionLevel: String, Codable {
  case fast = "fast"
  case accurate = "accurate"
}

struct RNTROptions {
  var visionIgnoreThreshold = 0.0
  var automaticallyDetectLanguage = true
  var recognitionLanguages: [String] = ["en-US"]
  var useLanguageCorrection = false
  var customWords: [String] = []
  var recognitionLevel: RecognitionLevel = .accurate
}

extension RNTROptions: Codable {
  init(dictionary: NSDictionary) throws {
    self.visionIgnoreThreshold = dictionary["visionIgnoreThreshold"] as? Double ?? 0.0
    self.automaticallyDetectLanguage = dictionary["automaticallyDetectLanguage"] as? Bool ?? true
    self.recognitionLanguages = dictionary["recognitionLanguages"] as? [String] ?? ["en-US"]
    self.useLanguageCorrection = dictionary["useLanguageCorrection"] as? Bool ?? false
    self.customWords = dictionary["customWords"] as? [String] ?? []
    self.recognitionLevel =
      RecognitionLevel(rawValue: dictionary["recognitionLevel"] as? String ?? "accurate")
      ?? .accurate
  }
}

struct StringProperties {

}

struct Exif {
  let ColorSpace: Int
  let PixelXDimension: Int
  let PixelYDimension: Int
}

struct Jfif {
  let DensityUnit: Int
  let JFIFVersion: [Int]
  let XDensity: Int
  let YDensity: Int
}

struct Tiff {
  let Orientation: Int
}

struct PNG {
  let InterlaceType: Int
  let XPixelsPerMeter: Int
  let YPixelsPerMeter: Int
}

struct ImageProperties {
  let ColorModel: String
  let Depth: Int
  let DPIHeight: Int
  let DPIWidth: Int
  let HasAlpha: Bool
  let Orientation: Int
  let PixelHeight: Int
  let PixelWidth: Int
  let ProfileName: String
  let Exif: Exif
  let JFIF: Jfif
  let TIFF: Tiff
  let PNG: PNG
}

//struct RecognitionResolve {
//  let stringProperties
//  let imageProperties
//}
