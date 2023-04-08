import { NativeModules } from 'react-native';

export type TextRecognitionOptions = {
  visionIgnoreThreshold?: number;
  automaticallyDetectLanguage?: boolean,
  recognitionLanguages?: SupportedLanuages[],
};

type TextRecognitionType = {
  recognize(
    imagePath: string,
    options?: TextRecognitionOptions
  ): Promise<string[]>;
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

async function recognize(
  imagePath: string,
  options?: TextRecognitionOptions
): Promise<string[]> {
  return await TextRecognition.recognize(imagePath, options || {});
}

export default { recognize } as TextRecognitionType;
