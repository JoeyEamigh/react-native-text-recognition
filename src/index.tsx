import { NativeModules } from 'react-native';

type TextRecognitionType = {
  multiply(a: number, b: number): Promise<number>;
};

const { TextRecognition } = NativeModules;

export default TextRecognition as TextRecognitionType;
