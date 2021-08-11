#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE (TextRecognition, NSObject)

RCT_EXTERN_METHOD(recognize
                  : (NSString *)imgPath withResolver
                  : (RCTPromiseResolveBlock)resolve withRejecter
                  : (RCTPromiseRejectBlock)reject)

@end
