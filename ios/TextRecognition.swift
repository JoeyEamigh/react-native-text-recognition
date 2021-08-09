@objc(TextRecognition)
class TextRecognition: NSObject {
  @objc(recognize:withResolver:withRejecter:)
  func recognize(imgPath: String, resolve: RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock) {
    resolve("It works!")
  }
}
