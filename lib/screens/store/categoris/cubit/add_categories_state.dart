part of 'add_categories_cubit.dart';

enum Submission {
  initial,
  editing,
  loading,
  success,
  failure,
}

class AddCategoriesItemState extends Equatable {
  final Uint8List? image;
  final Submission? submission;

  AddCategoriesItemState({this.image, this.submission = Submission.initial});

  AddCategoriesItemState copyWith({Uint8List? image, Submission? submission}) {
    return AddCategoriesItemState(
      image: image ?? this.image,
      submission: submission ?? this.submission,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    image,
    submission,
  ];
}