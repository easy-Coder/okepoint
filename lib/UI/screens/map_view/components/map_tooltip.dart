import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/theme/spacings.dart';

class CustomWindow extends StatelessWidget {
  const CustomWindow({Key? key, required this.info}) : super(key: key);
  final OkePointInfoWindow info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(6),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacings.elementSpacing * 0.5),
                      child: OkepointTexts.bodyText(
                        info.name,
                        context,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum InfoWindowType { currentPosition, destination }

class OkePointInfoWindow {
  final String name;
  final String? logoUrl;
  final String? address;

  final LatLng position;
  final InfoWindowType type;

  const OkePointInfoWindow({
    required this.name,
    this.logoUrl,
    this.address,
    required this.position,
    this.type = InfoWindowType.currentPosition,
  });
}
