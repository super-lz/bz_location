#import "AMapFlutterLocationPlugin.h"

static NSString *const BZLocationMethodChannel = @"bz_location";
static NSString *const BZLocationStreamChannel = @"bz_location_stream";

// Simulator-only fallback. It emits one deterministic location without
// linking the native AMap iOS SDK.
@interface AMapFlutterLocationPlugin () <FlutterStreamHandler>
@property(nonatomic, strong) FlutterEventSink eventSink;
@end

@implementation AMapFlutterLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  AMapFlutterLocationPlugin *instance = [[AMapFlutterLocationPlugin alloc] init];
  FlutterMethodChannel *methodChannel =
      [FlutterMethodChannel methodChannelWithName:BZLocationMethodChannel
                                  binaryMessenger:registrar.messenger];
  [registrar addMethodCallDelegate:instance channel:methodChannel];

  FlutterEventChannel *eventChannel =
      [FlutterEventChannel eventChannelWithName:BZLocationStreamChannel
                                binaryMessenger:registrar.messenger];
  [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"startLocation"]) {
    NSString *pluginKey = nil;
    if ([call.arguments isKindOfClass:[NSDictionary class]]) {
      pluginKey = call.arguments[@"pluginKey"];
    }
    [self emitStubLocationWithPluginKey:pluginKey];
    result(nil);
    return;
  }
  result(nil);
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  self.eventSink = events;
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  self.eventSink = nil;
  return nil;
}

- (void)emitStubLocationWithPluginKey:(NSString *)pluginKey {
  if (!self.eventSink) {
    return;
  }
  NSMutableDictionary *event = [@{
    @"callbackTime": @"simulator",
    @"locationTime": @"simulator",
    @"locationType": @0,
    @"latitude": @39.909187,
    @"longitude": @116.397451,
    @"accuracy": @0,
    @"altitude": @0,
    @"bearing": @0,
    @"speed": @0,
    @"address": @"iOS simulator stub location",
  } mutableCopy];
  if (pluginKey) {
    event[@"pluginKey"] = pluginKey;
  }
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
    if (self.eventSink) {
      self.eventSink(event);
    }
  });
}
@end
