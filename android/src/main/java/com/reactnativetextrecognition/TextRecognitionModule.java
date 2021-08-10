package com.reactnativetextrecognition;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.module.annotations.ReactModule;

// Deps
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
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
  public void recognize(String imgPath, @Nullable final ReadableMap options, Promise promise) {
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
                WritableArray textBlocks = new WritableNativeArray();

                for (Text.TextBlock block : visionText.getTextBlocks()) {
                  textBlocks.pushString(block.getText());
                }

                promise.resolve(textBlocks);
              }
            })
            .addOnFailureListener(
              new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                  Log.w(getName(), e);
                  promise.reject("something went wrong", e.getMessage());
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
}
