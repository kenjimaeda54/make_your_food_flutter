import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:make_your_travel/utils/typedef.dart';

class ButtonTypeTravel extends HookWidget {
  final OptionsTripPlan tripPlan;
  final Function() actionTapTypeTravel;
  final String idSelected;
  const ButtonTypeTravel(
      {super.key,
      required this.tripPlan,
      required this.idSelected,
      required this.actionTapTypeTravel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: actionTapTypeTravel,
      child: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: idSelected == tripPlan.id
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.secondary),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                tripPlan.imagePath,
                width: tripPlan.size,
                height: tripPlan.size,
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    idSelected == tripPlan.id
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn),
              ),
              Text(
                tripPlan.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: idSelected == tripPlan.id
                      ? FontWeight.w700
                      : FontWeight.w300,
                  color: idSelected == tripPlan.id
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
