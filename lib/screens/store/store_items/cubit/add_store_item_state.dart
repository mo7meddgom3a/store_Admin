part of 'add_store_item_cubit.dart';

enum Submission { initial, loading, success, failure }

class AddStoreItemState {
  final List<Uint8List>? images;
  final Submission submission;

  AddStoreItemState({
    this.images,
    this.submission = Submission.initial,
  });

  AddStoreItemState copyWith({
    List<Uint8List>? images,
    Submission? submission,
  }) {
    return AddStoreItemState(
      images: images ?? this.images,
      submission: submission ?? this.submission,
    );
  }
}
