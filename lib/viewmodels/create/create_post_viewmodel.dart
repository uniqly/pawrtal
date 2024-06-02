import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_viewmodel.g.dart';

class CreatePostViewModel { 
  final String _caption;
  final String _description;
  final String? _portalId;

  CreatePostViewModel([this._caption = '', this._description = '', this._portalId]);

  CreatePostViewModel copyWith({ 
      String? caption, String? description, String?  portalId}) {
    return CreatePostViewModel(
      caption ?? _caption,
      description ?? _description, 
      portalId ?? _portalId
    );
  }
  
  bool get emptyCaption => _caption.isEmpty;
  
  @override
  String toString() {
    return '$_caption, $_description, $_portalId';
  }
}

@riverpod
class CreatePostViewModelNotifier extends _$CreatePostViewModelNotifier {
  @override
  CreatePostViewModel build() {
    return CreatePostViewModel();
  }

  void updateForm({String? caption, String? description, String? portalId}) {
    state = state.copyWith(caption: caption, description: description, portalId: portalId);
  }
}



