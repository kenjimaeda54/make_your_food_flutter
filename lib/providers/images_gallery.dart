import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

typedef GalleryImageState = ({
  File? image,
  String id,
  DateTime dateTime,
});

class GalleryImageNotifier extends StateNotifier<List<GalleryImageState>> {
  GalleryImageNotifier() : super([]);

  fetchImagesGallery() async {
    final photoManager = await PhotoManager.requestPermissionExtend();

    if (photoManager.hasAccess) {
      PhotoManager.setIgnorePermissionCheck(true);
    }

    if (photoManager.isAuth) {
      final assets = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          filterOption: FilterOptionGroup(
              imageOption: const FilterOption(
                  needTitle: false,
                  sizeConstraint: SizeConstraint(ignoreSize: true))));

      for (var it in assets) {
        final countAssets = await it.assetCountAsync;
        if (countAssets < 1) return;
        final listAssets =
            await it.getAssetListRange(start: 0, end: countAssets);

        for (var asset in listAssets) {
          final imageFile = await asset.file ?? File("");
          final GalleryImageState stateGallery =
              (image: imageFile, id: asset.id, dateTime: asset.createDateTime);
          if (state.where((element) => element.id == asset.id).isEmpty) {
            state.add(stateGallery);
            state.sort((a, b) => b.dateTime.compareTo(a.dateTime));
          }
        }
      }
    }
  }
}

final galleryImageNotifierProvider =
    StateNotifierProvider<GalleryImageNotifier, List<GalleryImageState>>(
        (_) => GalleryImageNotifier());
