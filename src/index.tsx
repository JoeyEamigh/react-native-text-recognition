import { NativeModules } from 'react-native';

export type ResultBlock = {
  text: string // "Hello World", "안녕하세요 세계", etc
  languageCode: string // e.g. "en-US", "ko-KR", etc
  leftX: number
  middleX: number
  rightX: number
  bottomY: number
  middleY: number
  topY: number
  width: number
  height: number
}

export type TextRecognitionResult = ResultBlock[]

export type TextRecognitionOptions = {
  visionIgnoreThreshold?: number,
  automaticallyDetectLanguage?: boolean,
  recognitionLanguages?: SupportedLanuages[],
  useLanguageCorrection?: boolean,
  recognitionLevel?: RecognitionLevel,
  customWords?: string[],
};

type TextRecognitionType = {
  recognize(
    imagePath: string,
    options?: TextRecognitionOptions
  ): Promise<TextRecognitionResult[]>;
};

const { TextRecognition } = NativeModules;

/**
 * @iOS16 and higher: Revision 3 .accurate
 * ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant", "yue-Hans", "yue-Hant", "ko-KR", "ja-JP", "ru-RU", "uk-UA"]
 *
 * @iOS16 and higher: Revision 3 .fast
 * ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR"]
 *
 * @iOS14 and higher: Revision 2 .accurate
 * ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant"]
 *
 * @iOS14 and higher: Revision 2 .fast
 *  ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR"
 *
 */
type SupportedLanuages = "en-US" | "fr-FR" | "it-IT" | "de-DE" | "es-ES" | "pt-BR" | "zh-Hans" | "zh-Hant" | "yue-Hans" | "yue-Hant" | "ko-KR" | "ja-JP" | "ru-RU" | "uk-UA"
type RecognitionLevel = "fast" | "accurate";

async function recognize(
  imagePath: string,
  options?: TextRecognitionOptions
): Promise<TextRecognitionResult[]> {
  return await TextRecognition.recognize(imagePath, options || {});
}

export default { recognize } as TextRecognitionType;
