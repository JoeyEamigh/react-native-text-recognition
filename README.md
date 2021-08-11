# React-Native-Text-Recognition

Very basic text recognition utilizing Firebase ML for both iOS and Android

## Installation

```sh
yarn add react-native-text-recognition@ml
```

or with NPM:

```sh
npm install react-native-text-recognition@ml
```

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

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
