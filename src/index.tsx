import { NativeModules } from 'react-native';

type TextRecognitionType = {
  recognize(imagePath: string): Promise<{ text: string; confidence: number }[]>;
};

const { TextRecognition } = NativeModules;

export default TextRecognition as TextRecognitionType;
