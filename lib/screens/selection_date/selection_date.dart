import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/states/trip_search.dart';
import 'package:make_your_travel/utils/route_bottom_to_top_animated.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SelectionDate extends HookConsumerWidget {
  final bool isDateStart;
  SelectionDate({super.key, required this.isDateStart});

  static Route route({required bool isDateStart}) => RouteBottomToTopAnimated(
          widget: SelectionDate(
        isDateStart: isDateStart,
      ));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateSelected = useState<DateTime?>(null);

    DateTime handleMinDate() {
      if (isDateStart) {
        return DateTime.now();
      }

      if (!isDateStart && ref.read(tripSearch).dayStart != null) {
        return ref.read(tripSearch).dayStart!.add(const Duration(days: 1));
      }
      return DateTime.now().add(const Duration(days: 1));
    }

    Widget monthCellBuilder(MonthCellDetails details) {
      if (dateSelected.value != null &&
              details.date.isAtSameMomentAs(dateSelected.value!) ||
          dateSelected.value != null &&
              details.date.difference(dateSelected.value!).inDays == 0 &&
              details.date.difference(dateSelected.value!).inHours < 0) {
        return Container(
          width: 25,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            details.date.day.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
        );
      }

      if (!isDateStart && details.date.isBefore(handleMinDate())) {
        return Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            child: Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ));
      }

      if (details.date
          .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        return Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            child: Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ));
      }

      return Container(
          width: 25,
          height: 25,
          alignment: Alignment.center,
          child: Text(
            details.date.day.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ));
    }

    DateTime? initialSelectedDate() {
      if (isDateStart && ref.read(tripSearch).dayStart != null) {
        return ref.read(tripSearch).dayStart!;
      }

      if (isDateStart && ref.read(tripSearch).dayStart == null) {
        return DateTime.now();
      }

      if (!isDateStart && ref.read(tripSearch).dayEnd == null) {
        return ref.read(tripSearch).dayStart?.add(const Duration(days: 1)) ??
            DateTime.now().add(const Duration(days: 1));
      }

      return ref.read(tripSearch).dayEnd;
    }

    useEffect(() {
      dateSelected.value = initialSelectedDate();
    }, const []);

    return CustomScaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 13, right: 13),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: SfCalendar(
                  minDate: handleMinDate(),
                  todayHighlightColor: Colors.transparent,
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  viewHeaderStyle: ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: (calendarTapDetails) {
                    if (calendarTapDetails.date != null &&
                        calendarTapDetails.date!.isBefore(
                            DateTime.now().subtract(const Duration(days: 1)))) {
                      return;
                    }
                    dateSelected.value = calendarTapDetails.date;

                    final state = ref.read(tripSearch.notifier).state;
                    isDateStart
                        ? state.dayStart = dateSelected.value
                        : state.dayEnd = dateSelected.value;
                  },
                  viewHeaderHeight: 100,
                  view: CalendarView.month,
                  cellBorderColor: Colors.transparent,
                  monthCellBuilder: (context, details) =>
                      monthCellBuilder(details),
                  selectionDecoration:
                      const BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ));
  }
}
