import React, { useEffect, useRef } from 'react';
import { TouchableOpacity, StyleSheet, Text, Alert } from 'react-native';
import { useCameraDevices, Camera } from 'react-native-vision-camera';
import { recognize } from 'react-native-text-recognition';

export default function App() {
  const cameraRef = useRef<Camera>(null);
  const devices = useCameraDevices('wide-angle-camera');
  const device = devices.back;

  useEffect(() => {
    (async () => await handlePermissions())();
  }, []);

  if (device == null) return <></>;
  return (
    <>
      <Camera
        ref={cameraRef}
        device={device}
        isActive={true}
        style={StyleSheet.absoluteFill}
        photo={true}
        video={false}
      />
      <TouchableOpacity onPress={takePhoto} style={styles.button}>
        <Text style={styles.text}>Take Picture</Text>
      </TouchableOpacity>
    </>
  );

  async function takePhoto() {
    if (!cameraRef.current) throw new Error('Camera is not mounted');
    const photo = await cameraRef.current.takePhoto({});
    const object = await recognize(photo.path);
    const result = JSON.stringify(object, null, 2);
    console.log('result', result);
    Alert.alert('result', result);
  }

  async function handlePermissions() {
    const cameraPermission = await Camera.getCameraPermissionStatus();
    if (cameraPermission === 'not-determined') await Camera.requestCameraPermission();
    if (cameraPermission === 'denied') throw new Error('Camera or Microphone permissions are denied');
  }
}

const styles = StyleSheet.create({
  button: {
    position: 'absolute',
    bottom: 50,
    left: '50%',
    transform: [{ translateX: -50 }],
    width: 100,
    height: 100,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 10,
    borderRadius: 100,
    backgroundColor: 'red',
  },
  text: {
    color: 'white',
  },
});
