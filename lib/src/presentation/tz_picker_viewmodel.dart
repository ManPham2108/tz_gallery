import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class TzPickerViewModel {
  final ValueNotifier<List<AssetEntity>?> _entities = ValueNotifier(null);
  final ValueNotifier<List<AssetPathEntity>> _paths = ValueNotifier([]);

  List<AssetEntity>? get entities => _entities.value;
  List<AssetPathEntity> get paths => _paths.value;

  TzPickerViewModel._() {}
}
