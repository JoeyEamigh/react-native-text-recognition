import NaturalLanguage
import Vision

extension String {
  func stripPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

@available(iOS 13.0, *) // VNRecognizeTextRequest is a class introduced in the Vision framework in iOS 13.0
@objc(TextRecognition)
class TextRecognition: NSObject {
  @objc static func requiresMainQueueSetup() -> Bool { return true } // true, if the module needs to be initialized on the main thread
  @objc(recognize:withOptions:withResolver:withRejecter:)
  func recognize(imgPath: String, options: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard !imgPath.isEmpty else { reject("ERR", "You must include the image path", nil); return }

    let formattedImgPath = imgPath.stripPrefix("file://")
    var threshold: Float = 0.0

    var languages = ["en-US"]
    var autoDetectLanguage = true
    var customWords: [String] = []
    var usesLanguageCorrection = false
    var recognitionLevel: VNRequestTextRecognitionLevel = .accurate

    if let ignoreThreshold = options["visionIgnoreThreshold"] as? Float, !ignoreThreshold.isZero {
      threshold = ignoreThreshold
    }

    if let automaticallyDetectLanguage = options["automaticallyDetectLanguage"] as? Bool {
      autoDetectLanguage = automaticallyDetectLanguage
    }

    if let recognitionLanguages = options["recognitionLanguages"] as? [String] {
      languages = recognitionLanguages
    }

    if let words = options["customWords"] as? [String] {
      customWords = words
    }

    if let usesCorrection = options["usesLanguageCorrection"] as? Bool {
      usesLanguageCorrection = usesCorrection
    }

    if let level = options["recognitionLevel"] as? String, level == "fast" {
      recognitionLevel = .fast
    }

    do {
      let imgData = try Data(contentsOf: URL(fileURLWithPath: formattedImgPath))
      let image = UIImage(data: imgData)
      let imageSource = CGImageSourceCreateWithData(imgData as CFData, nil)
      let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil)

      guard let cgImage = image?.cgImage else { return }

      let requestHandler = VNImageRequestHandler(cgImage: cgImage)

      let ocrRequest = VNRecognizeTextRequest { (request: VNRequest, error: Error?) in
        self.recognizeTextHandler(request: request, threshold: threshold, error: error, imageProperties: imageProperties, resolve: resolve, reject: reject)
      }

      /* Revision 3, .accurate, iOS 16 and higher
       ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant", "yue-Hans", "yue-Hant", "ko-KR", "ja-JP", "ru-RU", "uk-UA"]
       */

      /* Revision 3, .fast, iOS 16 and higher
       ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR"]
       */

      /* Revision 2, .accurate, iOS 14 and higher
       ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant"]
       */

      /* Revision 2, .fast iOS, 14 and higher
       ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR"]
       */

      if #available(iOS 16.0, *) {
        if autoDetectLanguage {
          ocrRequest.automaticallyDetectsLanguage = true
        } else {
          ocrRequest.recognitionLanguages = languages
        }
      } else {
        ocrRequest.recognitionLanguages = languages
      }

      ocrRequest.customWords = customWords
      ocrRequest.usesLanguageCorrection = usesLanguageCorrection
      ocrRequest.recognitionLevel = recognitionLevel

      try requestHandler.perform([ocrRequest])
    } catch {
      print(error)
      reject("ERR", error.localizedDescription, nil)
    }
  }

  func recognizeTextHandler(request: VNRequest, threshold: Float, error _: Error?, imageProperties: CFDictionary?, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard let observations = request.results as? [VNRecognizedTextObservation] else { reject("ERR", "No text recognized.", nil); return }

    let recognizedStrings = observations.compactMap { observation -> [String: Any]? in
      guard let topCandidate = observation.topCandidates(1).first,
            topCandidate.confidence >= threshold else { return nil }

      let recognizedText = topCandidate.string

      _ = NLLanguageRecognizer()

      let language = NLLanguageRecognizer.dominantLanguage(for: recognizedText)

      let languageCode = language?.rawValue

      return ["text": recognizedText as String,
              "languageCode": languageCode ?? "unknown" as String,
              "confidence": topCandidate.confidence as Float, // Any to Float
              // "x": observation.boundingBox.origin.x as Any,
              // "y": observation.boundingBox.origin.y as Any,
              "leftX": Float(observation.boundingBox.minX),
              "middleX": Float(observation.boundingBox.midX),
              "rightX": Float(observation.boundingBox.maxX),
              "bottomY": Float(1 - observation.boundingBox.minY),
              "middleY": Float(1 - observation.boundingBox.midY),
              "topY": Float(1 - observation.boundingBox.maxY),
              "width": Float(observation.boundingBox.width),
              "height": Float(observation.boundingBox.height)]
    }

    // Debug
    // print(recognizedStrings)
    // get textProperties and properties from image
    let recognizedImageProperties = imageProperties as! [String: Any]
    resolve(["stringProperties": recognizedStrings as Any, "imageProperties": recognizedImageProperties as Any])
  }
}
