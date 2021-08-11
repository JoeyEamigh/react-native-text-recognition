import { NativeModules } from 'react-native';

type TextRecognitionType = {
  recognize(imagePath: string): Promise<string[]>;
};

const { TextRecognition } = NativeModules;

export default TextRecognition as TextRecognitionType;
