import Vision

extension String {
  func stripPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

@objc(TextRecognition)
class TextRecognition: NSObject {
  @objc static func requiresMainQueueSetup() -> Bool { return true }
  @objc(recognize:withOptions:withResolver:withRejecter:)
  func recognize(imgPath: String, options: [String: Float], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard !imgPath.isEmpty else { reject("ERR", "You must include the image path", nil); return }

    let formattedImgPath = imgPath.stripPrefix("file://")
    var threshold: Float = 0.0

    if !(options["visionIgnoreThreshold"]?.isZero ?? true) {
      threshold = options["visionIgnoreThreshold"] ?? 0.0
    }

    do {
      let imgData = try Data(contentsOf: URL(fileURLWithPath: formattedImgPath))
      let image = UIImage(data: imgData)

      guard let cgImage = image?.cgImage else { return }

      let requestHandler = VNImageRequestHandler(cgImage: cgImage)

      let ocrRequest = VNRecognizeTextRequest { (request: VNRequest, error: Error?) in
        self.recognizeTextHandler(request: request, threshold: threshold, error: error, resolve: resolve, reject: reject)
      }

      try requestHandler.perform([ocrRequest])
    } catch {
      print(error)
      reject("ERR", error.localizedDescription, nil)
    }
  }

  func recognizeTextHandler(request: VNRequest, threshold: Float, error _: Error?, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard let observations = request.results as? [VNRecognizedTextObservation] else { reject("ERR", "No text recognized.", nil); return }

//    let recognizedStrings = observations.compactMap { observation in
//      ["text": observation.topCandidates(1).first?.string as Any, "confidence": observation.topCandidates(1).first?.confidence as Any]
//    }

    let recognizedStrings = observations.compactMap { observation -> String? in
      if observation.topCandidates(1).first?.confidence ?? 0 >= threshold {
        return observation.topCandidates(1).first?.string
      } else {
        return nil
      }
    }

    // Debug
    // print(recognizedStrings)

    resolve(recognizedStrings)
  }
}
