import { NativeModules } from 'react-native';

export type ResultBlock = {
  confidence: number
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

export type StringProperties = {
  text: string // "Hello World", "안녕하세요 세계", etc
  languageCode: string // e.g. "en-US", "ko-KR", etc
  confidence: number
  leftX: number
  middleX: number
  rightX: number
  bottomY: number
  middleY: number
  topY: number
  width: number
  height: number
}

export type ImageProperties = {
  ColorModel: string
  Depth: number
  DPIHeight: number
  DPIWidth: number
  HasAlpha: boolean
  Orientation: number
  PixelHeight: number
  PixelWidth: number
  ProfileName: string
  "{Exif}": Exif
  "{JFIF}": Jfif
  "{TIFF}": Tiff
  "{PNG}": PNG
}

export type Exif = {
  ColorSpace: number
  PixelXDimension: number
  PixelYDimension: number
}
export type Jfif = {
  DensityUnit: number
  JFIFVersion: number[]
  XDensity: number
  YDensity: number
}
export type Tiff = {
  Orientation: number
}
export type PNG = {
  InterlaceType: number
  XPixelsPerMeter: number
  YPixelsPerMeter: number
}

export type TextRecognitionOptions = {
  visionIgnoreThreshold?: number,
  automaticallyDetectLanguage?: boolean,
  recognitionLanguages?: SupportedLanuages[],
  useLanguageCorrection?: boolean,
  recognitionLevel?: RecognitionLevel,
  customWords?: string[],
};

export type TextRecognitionResult = {
  stringProperties: StringProperties[],
  imageProperties: ImageProperties
}

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
