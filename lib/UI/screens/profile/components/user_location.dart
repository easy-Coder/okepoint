import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/components/cards/blur.dart';
import 'package:okepoint/UI/components/cards/paddings.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/theme/spacings.dart';

import '../../../../data/models/point.dart';
import '../../../../data/services/map_service.dart';
import '../../../components/cards/list_tile.dart';

class UserLocation extends ConsumerWidget {
  const UserLocation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapProvider = ref.watch(mapServiceProvider);

    return ValueListenableBuilder<LocationPoint?>(
        valueListenable: mapProvider.currentUserLocationPointNotifier,
        builder: (context, location, _) {
          if (location == null) return const SizedBox.shrink();
          return CardPadding(
            child: Container(
              padding: const EdgeInsets.all(AppSpacings.cardPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OkepointTexts.subHeading("My Location", context, fontWeight: FontWeight.w600),
                  const SizedBox(height: AppSpacings.elementSpacing),
                  const Divider(height: AppSpacings.cardPadding),
                  OkeListTile(
                    title: OkepointTexts.bodyText("Location", context),
                    trailing: Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacings.cardPadding),
                                  scrollDirection: Axis.horizontal,
                                  child: OkepointTexts.bodyText(
                                    location.name,
                                    context,
                                    color: Theme.of(context).unselectedWidgetColor,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: BlurCardArea(
                                    color: Theme.of(context).cardColor,
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: BlurCardArea(
                                    color: Theme.of(context).cardColor,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacings.elementSpacing),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).unselectedWidgetColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: AppSpacings.cardPadding),
                  OkeListTile(
                    title: OkepointTexts.bodyText("From", context),
                    trailing: Row(
                      children: [
                        OkepointTexts.bodyText(
                          "This iPhone",
                          context,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: AppSpacings.cardPadding),
                  OkeListTile(
                    title: OkepointTexts.bodyText("Share My Location", context),
                    trailing: CupertinoSwitch(value: true, onChanged: (_) {}),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
