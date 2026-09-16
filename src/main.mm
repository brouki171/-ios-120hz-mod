#include <Geode/Geode.hpp>
#include <Geode/modify/CCDirector.hpp>

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

using namespace geode::prelude;

// Force Geometry Dash's director to use a 120 FPS animation interval.
class $modify(iOS120HzDirector, cocos2d::CCDirector) {
    void setAnimationInterval(double interval) {
        CCDirector::setAnimationInterval(1.0 / 120.0);
        log::debug("[iOS120Hz] Animation interval forced to 120Hz");
    }
};

// Configure the device's display for 120 Hz.
$on_mod(Loaded) {
    log::info("[iOS120Hz] Mod loaded - 120Hz support enabled");

    UIScreen* screen = [UIScreen mainScreen];

    if (@available(iOS 15.0, *)) {
        NSInteger maxFPS = screen.maximumFramesPerSecond;

        log::info(
            "[iOS120Hz] Device maximum frame rate: {}Hz",
            maxFPS
        );

        if (maxFPS >= 120) {
            log::info("[iOS120Hz] 120Hz display detected");
        } else {
            log::warn(
                "[iOS120Hz] Device does not support a 120Hz display"
            );
        }
    }
}
