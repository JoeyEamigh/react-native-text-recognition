package com.textrecognition

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions


class TextRecognitionModule(context: ReactApplicationContext) :
    ReactContextBaseJavaModule(context) {

    override fun getName() = "TextRecognition"

    @ReactMethod
    fun recognize(imgPath: String, options: ReadableMap, promise: Promise) {
        val RNTROptions = RNTROptions().from(options)
        val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)

        var imageProperties = ImageProperties()

        var bitmap = getBitmap(imgPath)
            ?: return promise.reject("something went wrong", Exception ("cannot get bitmap"));

        imageProperties.ColorModel = bitmap.config.name
        imageProperties.DPIHeight = bitmap.density
        imageProperties.DPIWidth = bitmap.density
        imageProperties.HasAlpha = bitmap.hasAlpha()
        imageProperties.PixelHeight = bitmap.height
        imageProperties.PixelWidth = bitmap.width

        val rotationDegree = 0
        val image = InputImage.fromBitmap(bitmap, rotationDegree)
        val textTask = recognizer.process(image)

        if (!textTask.isSuccessful)
            return promise.reject("something went wrong", textTask.exception)

        val returnValue = ReturnValue()
        returnValue.imageProperties = imageProperties
        returnValue.stringProperties = mutableListOf<StringProperties>()

        for (block in textTask.result.textBlocks) {
            for (line in block.lines) {
                var stringProperties = StringProperties()
                stringProperties.text = line.text
                stringProperties.languageCode = line.recognizedLanguage.toString()
                stringProperties.confidence = line.confidence
                stringProperties.leftX = line.boundingBox?.left ?: 0
                stringProperties.middleX = line.boundingBox?.centerX() ?: 0
                stringProperties.rightX = line.boundingBox?.right ?: 0
                stringProperties.bottomY = line.boundingBox?.bottom ?: 0
                stringProperties.middleY = line.boundingBox?.centerY() ?: 0
                stringProperties.topY = line.boundingBox?.top ?: 0
                stringProperties.width = line.boundingBox?.width() ?: 0
                stringProperties.height = line.boundingBox?.height() ?: 0

                returnValue.stringProperties.add(stringProperties)
            }
        }

        promise.resolve(returnValue)
    }

    @Throws(Exception::class)
    private fun getBitmap(imageSource: String): Bitmap? {
        if (imageSource.startsWith("http://") || imageSource.startsWith("https://")) throw Exception(
            "Cannot select remote files"
        );

        val path = if (imageSource.startsWith("file://")) imageSource.replace(
            "file://",
            ""
        ) else imageSource

        return BitmapFactory.decodeFile(path, BitmapFactory.Options())
    }
}
