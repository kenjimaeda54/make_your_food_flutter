import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShowGalleryCamera extends HookWidget {
  const ShowGalleryCamera({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollList = useScrollController();
    final sheetPosition = useState(0.5);

    scrollListener() {
      if (scrollList.position.isScrollingNotifier.value &&
          sheetPosition.value < 0.8) {
        sheetPosition.value += 0.1;
      }
    }

    useEffect(() {
      scrollList.addListener(scrollListener);
    }, const []);

    return DraggableScrollableSheet(
      initialChildSize: sheetPosition.value,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
                controller: scrollList,
                itemCount: 50,
                itemBuilder: (context, index) {
                  return Text("ola");
                }));
      },
    );
  }
}
