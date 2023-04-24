package com.textrecognition

enum class RecognitionLevel {
  FAST = "fast",
  ACCURATE = "accurate"
}


// class RNTROptions: NSObject {
//   let visionIgnoreThreshold: Float = 0.0
//   let automaticallyDetectLanguage = true
//   let recognitionLanguages = ["en-US"]
//   let useLanguageCorrection = false
//   let customWords: [String] = []
//   let recognitionLevel: RecognitionLevel = 'accurate'
// }

public class RNTROptions {
  public final float visionIgnoreThreshold = 0.0f;
  public final boolean automaticallyDetectLanguage = true;
  public final String[] recognitionLanguages = {"en-US"};
  public final boolean useLanguageCorrection = false;
  public final String[] customWords = {};
  public final String recognitionLevel = "accurate";
}