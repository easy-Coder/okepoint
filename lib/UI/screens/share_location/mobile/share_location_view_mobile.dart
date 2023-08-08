import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/services/map_service.dart';
import 'package:okepoint/data/states/user_state.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/cards/blur.dart';
import '../../../components/cards/paddings.dart';
import '../../../theme/spacings.dart';
import '../components/emergencies.dart';
import '../components/header.dart';
import '../components/selected_emergency.dart';
import '../share_location_state.dart';

class ShareLocationViewWidget extends ConsumerWidget {
  const ShareLocationViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapService = ref.read(mapServiceProvider);
    final selectedEmergency = ref.watch(selectedEmergencyProvider);
    final userNotifier = ref.read(userStateProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([
            mapService.enabledLocationSharing,
          ]),
          builder: (context, _) {
            final isEnabled = mapService.enabledLocationSharing.value;

            return CardPadding(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacings.cardPadding),
                          child: Column(
                            children: [
                              if (!isEnabled) ...[
                                const HomeHeader(),
                                const Emergencies(),
                              ] else if (selectedEmergency != null)
                                const SelectedEmergency()
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: BlurCardArea(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OkepointPrimaryButton(
                    title: isEnabled ? "Stop Sharing" : "Start Sharing Location",
                    color: isEnabled ? Theme.of(context).colorScheme.error : null,
                    state: ButtonState.initial,
                    onPressed: () {
                      if (isEnabled) {
                        mapService.cancelRealtimeLocationShare();
                        return;
                      }

                      mapService.shareLocationRealtime(
                        (location) => userNotifier.updateCurrentUserSharedLocation(
                          selectedEmergency!,
                          location: location,
                          isEnabled: isEnabled,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacings.cardPadding),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
