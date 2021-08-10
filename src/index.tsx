import { NativeModules, Platform } from 'react-native';

export type TextRecognitionOptions = {
  visionIgnoreThreshold?: number;
};

type TextRecognitionType = {
  recognize(
    imagePath: string,
    options?: TextRecognitionOptions
  ): Promise<string[]>;
};

const { TextRecognition } = NativeModules;

async function recognize(
  imagePath: string,
  options?: TextRecognitionOptions
): Promise<string[]> {
  return Platform.select({
    ios: await TextRecognition.recognize(imagePath, options || {}),
    android: await TextRecognition.recognize(imagePath),
  });
}

export default { recognize } as TextRecognitionType;
