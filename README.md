# React-Native-Text-Recognition

Very basic text recognition utilizing the Vision framework on iOS and Firebase ML on Android

## Installation

```sh
yarn add react-native-text-recognition
```

or with NPM:

```sh
npm install react-native-text-recognition
```

<hr>

### iOS:

<b>Make sure that your Podfile's minimum deployment target is 13.0 or greater!!</b>

If you get an error about "Could not find or use auto-linked library 'xxxxx'" then add the following to your project's Build Settings under LIBRARY_SEARCH_PATHS:

```
"$(SDKROOT)/usr/lib/swift"
```

This error is most common on XCode 12+

<hr>

## Usage

```js
import TextRecognition from 'react-native-text-recognition';

// pass the image's path to recognize

const result = await TextRecognition.recognize('/var/mobile/...');
```

### Configuration and Options

There is an optional configuration object affecting iOS vision only. It includes one key, `visionIgnoreThreshold` which is a number (<= 1).

```ts
type TextRecognitionOptions = {
  visionIgnoreThreshold?: number;
};
```

It is used at the end of the `recognize` function:

```js
const result = await TextRecognition.recognize('/var/mobile/...', {
  visionIgnoreThreshold: 0.5,
});
```

The only thing that this changes is whether or not to return a recognized string based on the Vision Framework's "confidence." You can read more at [https://developer.apple.com/documentation/vision/vnobservation/2867220-confidence/](https://developer.apple.com/documentation/vision/vnobservation/2867220-confidence/)

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
