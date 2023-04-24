import { NativeModules, Platform } from 'react-native';
import type { TextRecognitionOptions, TextRecognitionResult } from './types';

const LINKING_ERROR =
  `The package 'react-native-text-recognition' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const NativeTextRecognition = NativeModules.TextRecognition
  ? NativeModules.TextRecognition
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      },
    );

async function recognize(imagePath: string, options: TextRecognitionOptions = {}): Promise<TextRecognitionResult[]> {
  return await NativeTextRecognition.recognize(imagePath, options);
}

export { recognize };
