#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE (TextRecognition, NSObject)

RCT_EXTERN_METHOD(recognize
                  : (NSString *)imgPath withOptions
                  : (NSDictionary *)options withResolver
                  : (RCTPromiseResolveBlock)resolve withRejecter
                  : (RCTPromiseRejectBlock)reject)

@end
