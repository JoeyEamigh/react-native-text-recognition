# React-Native-Text-Recognition

Very basic text recognition utilizing Firebase ML for both iOS and Android

I also have a version that utilizes Firebase ML on both iOS and Android. You can check that out or install it on the [ml-only](https://github.com/JoeyEamigh/react-native-text-recognition/tree/ml-only) branch!

## NOTE:

I do not do much React Native anymore, so this project is largely unmaintained. If someone wants to join as a contributor, I would be happy have a conversation!

## Installation

```sh
yarn add react-native-text-recognition@ml
```

or with NPM:

```sh
npm install react-native-text-recognition@ml
```

<hr>

### Android

When using a version >= 1.1.0 Android is using MLKit v2 Beta, which simply means that you do not need Google Play services to use MLKit. If you want your app binary to be smaller and are sure that all devices installing the app will have Google Play, use version 1.0.1.

<hr>

### iOS:

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

### Android:

If you are using [react-native-camera](https://github.com/react-native-camera/react-native-camera) and not getting good reads back, set `fixOrientation: true` in the settings for `takePictureAsync`. This will cause a noticable delay in processing but fix the issue. This is most common (for me) on OnePlus phones.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
