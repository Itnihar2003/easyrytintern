import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class Initializationhelper {
  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();

    // ConsentDebugSettings debugSettings = ConsentDebugSettings(
    //     debugGeography: DebugGeography.debugGeographyEea);
    // ConsentRequestParameters params =
    //     ConsentRequestParameters(consentDebugSettings: debugSettings);
   final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        await _loadconcentform();
      } else {
        await _initialize();
      }
      completer.complete();
    }, (error) {
      completer.complete(error);
    });
    return completer.future;
  }

  Future<FormError?> _loadconcentform() async {
    final completer = Completer<FormError?>();
    ConsentForm.loadConsentForm((consentForm) async {
      final status = await ConsentInformation.instance.getConsentStatus();
      if (status == ConsentStatus.required) {
        consentForm.show((formError) {
          completer.complete(_loadconcentform());
        });
      } else {
        await _initialize();

        completer.complete();
      }
    }, (formError) {
      completer.complete(formError);
    });
    return completer.future;
  }

  Future<void> _initialize() async {
    await MobileAds.instance.initialize();
  }
}
