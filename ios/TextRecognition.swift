import NaturalLanguage
import Vision

extension String {
  func stripPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

@objc(TextRecognition)
class TextRecognition: NSObject {
  @objc(recognize:withOptions:withResolver:withRejecter:)
  func recognize(imgPath: String, options: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard !imgPath.isEmpty else { reject("ERR", "You must include the image path", nil); return }

    let formattedImgPath = imgPath.stripPrefix("file://")
    var threshold: Float = 0.0

    var languages = ["en-US"]
    var autoDetectLanguage = true
    var customWords: [String] = []
    var useLanguageCorrection = false
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
      useLanguageCorrection = usesCorrection
    }

    if let level = options["recognitionLevel"] as? String, level == "fast" {
      recognitionLevel = .fast
    }

    do {
      let imgData = try Data(contentsOf: URL(fileURLWithPath: formattedImgPath))
      let image = UIImage(data: imgData)

      guard let cgImage = image?.cgImage else { return }

      let requestHandler = VNImageRequestHandler(cgImage: cgImage)

      let ocrRequest = VNRecognizeTextRequest { (request: VNRequest, error: Error?) in
        self.recognizeTextHandler(request: request, threshold: threshold, error: error, resolve: resolve, reject: reject)
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

      if autoDetectLanguage {
        if #available(iOS 16.0, *) {
          ocrRequest.automaticallyDetectLanguage = true
        } else {
          ocrRequest.recognitionLanguages = languages
        }
      } else {
        ocrRequest.recognitionLanguages = languages
      }

      ocrRequest.customWords = customWords
      ocrRequest.usesLanguageCorrection = useLanguageCorrection
      ocrRequest.recognitionLevel = recognitionLevel

      try requestHandler.perform([ocrRequest])
    } catch {
      print(error)
      reject("ERR", error.localizedDescription, nil)
    }
  }

  func recognizeTextHandler(request: VNRequest, threshold: Float, error _: Error?, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard let observations = request.results as? [VNRecognizedTextObservation] else { reject("ERR", "No text recognized.", nil); return }

    let recognizedStrings = observations.compactMap { observation -> [String: Any]? in
      guard let topCandidate = observation.topCandidates(1).first,
            topCandidate.confidence >= threshold else { return nil }

      let recognizedText = topCandidate.string

      _ = NLLanguageRecognizer()

      let language = NLLanguageRecognizer.dominantLanguage(for: recognizedText)

      let languageCode = language?.rawValue

      return ["text": recognizedText, "languageCode": languageCode ?? "[Unknown]"]
    }

    // Debug
    // print(recognizedStrings)

    resolve(recognizedStrings)
  }
}
