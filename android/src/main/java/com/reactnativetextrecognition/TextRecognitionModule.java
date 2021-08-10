package com.reactnativetextrecognition;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

// Deps
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraManager;
import android.os.Build;
import android.util.Log;
import android.net.Uri;
import android.util.SparseIntArray;
import android.view.Surface;

import java.io.IOException;

// ML
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.text.Text;
import com.google.mlkit.vision.text.TextRecognition;
import com.google.mlkit.vision.text.TextRecognizer;
import com.google.mlkit.vision.text.TextRecognizerOptions;

@ReactModule(name = TextRecognitionModule.NAME)
public class TextRecognitionModule extends ReactContextBaseJavaModule {
  public static final String NAME = "TextRecognition";
  private final ReactApplicationContext reactContext;

  public TextRecognitionModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }


  @ReactMethod
  public void recognize(String imgPath, Promise promise) {
    Log.v(getName(), "image path: " + imgPath);

    try {
      final Bitmap bitmap = getBitmap(imgPath);

      if (bitmap != null) {
        TextRecognizer recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS);

        int rotationDegree = 0;
        InputImage image = InputImage.fromBitmap(bitmap, rotationDegree);

        Task<Text> result =
          recognizer.process(image)
            .addOnSuccessListener(new OnSuccessListener<Text>() {
              @Override
              public void onSuccess(Text visionText) {
                Log.v(getName(), visionText.getText());
              }
            })
            .addOnFailureListener(
              new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                  Log.w(getName(), e);
                }
              });
      } else {
        throw new IOException("Could not decode a file path into a bitmap.");
      }
    }
    catch(Exception e) {
      Log.w(getName(), e.toString(), e);
      promise.reject("something went wrong", e.getMessage());
    }
  }

  private Bitmap getBitmap(String imageSource) throws Exception {
    String path = imageSource.startsWith("file://") ? imageSource.replace("file://", "") : imageSource;

    if (path.startsWith("http://") || path.startsWith("https://")) {
      throw new Exception("Cannot select remote files");
    }

    return BitmapFactory.decodeFile(path, new BitmapFactory.Options());
  }

//  private static final SparseIntArray ORIENTATIONS = new SparseIntArray();
//  static {
//    ORIENTATIONS.append(Surface.ROTATION_0, 0);
//    ORIENTATIONS.append(Surface.ROTATION_90, 90);
//    ORIENTATIONS.append(Surface.ROTATION_180, 180);
//    ORIENTATIONS.append(Surface.ROTATION_270, 270);
//  }
//
//  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
//  private int getRotationCompensation(String cameraId, Activity activity, boolean isFrontFacing)
//    throws CameraAccessException {
//    // Get the device's current rotation relative to its "native" orientation.
//    // Then, from the ORIENTATIONS table, look up the angle the image must be
//    // rotated to compensate for the device's rotation.
//    int deviceRotation = activity.getWindowManager().getDefaultDisplay().getRotation();
//    int rotationCompensation = ORIENTATIONS.get(deviceRotation);
//
//    // Get the device's sensor orientation.
//    CameraManager cameraManager = (CameraManager) activity.getSystemService(CAMERA_SERVICE);
//    int sensorOrientation = cameraManager
//      .getCameraCharacteristics(cameraId)
//      .get(CameraCharacteristics.SENSOR_ORIENTATION);
//
//    if (isFrontFacing) {
//      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//    } else { // back-facing
//      rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
//    }
//    return rotationCompensation;
//  }
}
