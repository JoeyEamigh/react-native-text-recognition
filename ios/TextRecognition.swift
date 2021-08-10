import Vision

extension String {
  func stripPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

@objc(TextRecognition)
class TextRecognition: NSObject {
  @objc(recognize:withResolver:withRejecter:)
  func recognize(imgPath: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard !imgPath.isEmpty else { reject("ERR", "You must include the image path", nil); return }
    let formattedImgPath = imgPath.stripPrefix("file://")

    do {
      let imgData = try Data(contentsOf: URL(fileURLWithPath: formattedImgPath))
      let image = UIImage(data: imgData)

      guard let cgImage = image?.cgImage else { return }

      let requestHandler = VNImageRequestHandler(cgImage: cgImage)

      let ocrRequest = VNRecognizeTextRequest { (request: VNRequest, error: Error?) in
        self.recognizeTextHandler(request: request, error: error, resolve: resolve, reject: reject)
      }

      try requestHandler.perform([ocrRequest])
    } catch {
      print(error)
      reject("ERR", error.localizedDescription, nil)
    }
  }

  func recognizeTextHandler(request: VNRequest, error _: Error?, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard let observations = request.results as? [VNRecognizedTextObservation] else { reject("ERR", "No text recognized.", nil); return }

    let recognizedStrings = observations.compactMap { observation in
      ["text": observation.topCandidates(1).first?.string as Any, "confidence": observation.topCandidates(1).first?.confidence as Any]
    }

    // Debug
    // print(recognizedStrings)

    resolve(recognizedStrings)
  }
}
