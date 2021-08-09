@objc(TextRecognition)
class TextRecognition: NSObject {
  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve: RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock) {
    resolve(a * b)
  }
}
