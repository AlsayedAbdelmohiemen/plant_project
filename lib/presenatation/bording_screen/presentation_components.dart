import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:final2/presenatation/bording_screen/page_view.dart';
import 'package:flutter/cupertino.dart';
import 'Onboarding_item.dart';

class PresentationComponents extends StatelessWidget {
  const PresentationComponents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return OnboardingPageView(
      onboardingItems: [
        OnboardingItem(
          imagePath: "assets/images/pana.png",
          title: local.onboardTitle1,
          subtitle: local.onboardSubtitle1,
        ),
        OnboardingItem(
          imagePath: "assets/images/cuate.png",
          title: local.onboardTitle2,
          subtitle: local.onboardSubtitle2,
        ),
        OnboardingItem(
          imagePath: "assets/images/bro.png",
          title: local.onboardTitle3,
          subtitle: local.onboardSubtitle3,
        ),
      ],
    );
  }
}