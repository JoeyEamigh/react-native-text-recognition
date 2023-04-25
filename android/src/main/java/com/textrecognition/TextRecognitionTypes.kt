package com.textrecognition

import com.facebook.react.bridge.ReadableMap

public class RNTROptions {
    // mlkit doesnt seem to have any options

    public fun from(options: ReadableMap) {
        // mlkit doesnt seem to have any options
    }
}

public class ImageProperties {
    public var ColorModel: String = "";
    public var DPIHeight: Int = 0;
    public var DPIWidth: Int = 0;
    public var HasAlpha: Boolean = false;
    public var PixelHeight: Int = 0;
    public var PixelWidth: Int = 0;
//    public var Exif: Exif = Exif();
//    public var Jfif: Jfif = Jfif();
//    public var Tiff: Tiff = Tiff();
//    public var PNG: PNG = PNG();
}

//public class Exif {
//    public var ColorSpace: Int = 0;
//    public var PixelXDimension: Int = 0;
//    public var PixelYDimension: Int = 0;
//}
//
//public class Jfif {
//    public var DensityUnit: Int = 0;
//    public var JFIFVersion: List<Int> = listOf<Int>();
//    public var XDensity: Int = 0;
//    public var YDensity: Int = 0;
//}
//
//public class Tiff {
//    public var Orientation: Int = 0;
//}
//
//public class PNG {
//    public var InterlaceType: Int = 0;
//    public var XPixelsPerMeter: Int = 0;
//    public var YPixelsPerMeter: Int = 0;
//}
public class StringProperties {
    public var text: String = "";
    public var languageCode: String = "";
    public var confidence = 0.0F;
    public var leftX = 0;
    public var middleX = 0;
    public var rightX = 0;
    public var bottomY = 0;
    public var middleY = 0;
    public var topY = 0;
    public var width = 0;
    public var height = 0;
}

public class ReturnValue {
    public var imageProperties: ImageProperties = ImageProperties();
    public var stringProperties: MutableList<StringProperties> = mutableListOf<StringProperties>();
}