#include <Geode/Geode.hpp>

using namespace geode::prelude;

$on_mod(Loaded) {
    log::info("[iOS120Hz TEST] DLL LOADED SUCCESSFULLY");

    FLAlertLayer::create(
        "iOS 120Hz Test",
        "The iOS 120Hz mod DLL is running!",
        "OK"
    )->show();
}
