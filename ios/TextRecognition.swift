import MLImage
import MLKitTextRecognition
import MLKitVision

extension String {
  func stripPrefix(_ prefix: String) -> String {
    guard hasPrefix(prefix) else { return self }
    return String(dropFirst(prefix.count))
  }
}

@objc(TextRecognition)
class TextRecognition: NSObject {
  @objc static func requiresMainQueueSetup() -> Bool { return true }
  @objc(recognize:withResolver:withRejecter:)
  func recognize(imgPath: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    guard !imgPath.isEmpty else { reject("ERR", "You must include the image path", nil); return }

    let formattedImgPath = imgPath.stripPrefix("file://")

    do {
      let imgData = try Data(contentsOf: URL(fileURLWithPath: formattedImgPath))
      let image = UIImage(data: imgData)!

      let visionImage = VisionImage(image: image)
      visionImage.orientation = image.imageOrientation

      let textRecognizer = TextRecognizer.textRecognizer()

      textRecognizer.process(visionImage) { result, error in
        guard error == nil, let result = result else { return }

        // debug
        let resultText = result.text
        print(resultText)

        var recognizedTextBlocks = [String]()

        for block in result.blocks {
          recognizedTextBlocks.append(block.text)
        }

        resolve(recognizedTextBlocks)
      }
    } catch {
      print(error)
      reject("ERR", error.localizedDescription, nil)
    }
  }
}
