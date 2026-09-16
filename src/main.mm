#include <Geode/Geode.hpp>
#include <Geode/modify/AppDelegate.hpp>
#include <Geode/modify/CCDirector.hpp>

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

using namespace geode::prelude;

// Force Geometry Dash's main display link to prefer 120 Hz.
static void configure120HzDisplayLink(CADisplayLink* displayLink) {
    if (!displayLink) {
        return;
    }

    if (@available(iOS 15.0, *)) {
        displayLink.preferredFrameRateRange =
            CAFrameRateRangeMake(120.0, 120.0, 120.0);
    } else {
        displayLink.preferredFramesPerSecond = 120;
    }
}

// Hook into AppDelegate.
class $modify(iOS120HzAppDelegate, AppDelegate) {
    bool applicationDidFinishLaunching() {
        if (!AppDelegate::applicationDidFinishLaunching()) {
            return false;
        }

        log::info("[iOS120Hz] Initializing 120Hz support...");

        UIApplication* app = [UIApplication sharedApplication];
        UIWindow* keyWindow = nil;

        for (UIWindow* window in app.windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }

        if (!keyWindow && app.windows.count > 0) {
            keyWindow = app.windows[0];
        }

        if (keyWindow) {
            UIScreen* screen = keyWindow.screen;

            if (@available(iOS 15.0, *)) {
                log::info(
                    "[iOS120Hz] Device maximum frame rate: {}Hz",
                    screen.maximumFramesPerSecond
                );
            }

            // Create a display link that runs on the main run loop.
            CADisplayLink* displayLink =
                [CADisplayLink displayLinkWithTarget:keyWindow
                                             selector:@selector(iOS120Hz_tick:)];

            if (displayLink) {
                configure120HzDisplayLink(displayLink);

                [displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                                  forMode:NSDefaultRunLoopMode];

                log::info("[iOS120Hz] Display link configured for 120Hz");
            }
        }

        return true;
    }
};

// Hook CCDirector to force the game animation interval to 120 FPS.
class $modify(iOS120HzDirector, CCDirector) {
    void setAnimationInterval(double interval) {
        CCDirector::setAnimationInterval(1.0 / 120.0);
        log::debug("[iOS120Hz] Animation interval forced to 120Hz");
    }

    void setNextDeltaTimeZero(bool nextDeltaTimeZero) {
        CCDirector::setNextDeltaTimeZero(nextDeltaTimeZero);
    }
};

// Mod initialization.
$on_mod(Loaded) {
    log::info("[iOS120Hz] Mod loaded - 120Hz support enabled");

    UIScreen* mainScreen = [UIScreen mainScreen];

    if (@available(iOS 15.0, *)) {
        NSInteger maxFPS = mainScreen.maximumFramesPerSecond;

        log::info(
            "[iOS120Hz] Device maximum frame rate: {}Hz",
            maxFPS
        );

        if (maxFPS < 120) {
            log::warn(
                "[iOS120Hz] Device does not support a 120Hz display"
            );
        }
    }
}
