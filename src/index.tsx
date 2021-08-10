import { NativeModules } from 'react-native';

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
  return await TextRecognition.recognize(imagePath, options || {});
}

export default { recognize } as TextRecognitionType;
