import 'package:anwer_shop_admin/constants.dart';
import 'package:anwer_shop_admin/loader/loading_indicator.dart';
import 'package:anwer_shop_admin/screens/store/categoris/cubit/categories_cubit.dart';
import 'package:anwer_shop_admin/screens/store/store_items/cubit/store_cubit.dart';
import 'package:anwer_shop_admin/screens/store/store_items/cubit/store_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/scrol_cubit.dart';
import '../widgets/categories_form.dart';
import '../widgets/custom_check_box_widget.dart';

class StoreItemsWidget extends StatelessWidget {
  const StoreItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<StoreCubit>().loadStoreItems();
    context.read<CategoriesCubit>().loadCategoriesNames();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "العناصر في المتجر",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: defaultPadding,
        ),
        BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            if (state is StoreLoading) {
              return Center(
                  child: loadingIndicator(
                    color: Colors.white,
                  ));
            } else if (state is StoreLoaded) {
              return SizedBox(
                width: double.infinity,
                child: DataTable(
                  horizontalMargin: 50,
                  dataRowMinHeight: 100,
                  dataRowMaxHeight: 200,
                  // columnSpacing: defaultPadding,
                  columns: [
                    DataColumn(
                      label: Text("صورة المنتج"),
                    ),
                    DataColumn(
                      label: Text("اسم المنتج"),
                    ),
                    DataColumn(
                      label: Text("الفئة"),
                    ),
                    DataColumn(
                      label: Text("الكمية"),
                    ),
                    DataColumn(
                      label: Text("سعر المنتج"),
                    ),
                    DataColumn(
                      label: Text("الإجراءات"),
                    ),
                  ],
                  rows: List.generate(
                    state.items.length,
                        (index) => foundDataRow(state.items[index]),
                  ),
                ),
              );
            } else {
              return Container(); // Handle other states if needed
            }
          },
        ),
      ],
    );
  }

  DataRow foundDataRow(StoreItem item) {
    return DataRow(
      cells: [
        DataCell(
          MyImageScrollWidget(imageUrls: item.imageUrl),
        ),
        DataCell(Text(item.name)),
        DataCell(Text(item.category ?? "")),
        DataCell(Text("${item.Quantity}")),
        DataCell(Text("${item.price}")),
        DataCell(
          BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              if (state is StoreLoading) {
                return Center(
                    child: loadingIndicator(
                      color: Colors.white,
                    ));
              }
              return Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text("حذف الفئة"),
                              content: Text(
                                  "هل أنت متأكد أنك تريد حذف هذه الفئة؟"),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: Text("إلغاء",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<StoreCubit>()
                                        .deleteStoreItem(item.documentId);
                                    Navigator.pop(context);
                                  },
                                  child: Text("حذف",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("تعديل المنتج"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  initialValue: item.name,
                                  decoration: InputDecoration(
                                    labelText: "اسم المنتج",
                                  ),
                                  onChanged: (value) {
                                    item.name = value;
                                  },
                                ),
                                TextFormField(
                                  initialValue: "${item.price}",
                                  decoration: InputDecoration(
                                    labelText: "سعر المنتج",
                                  ),
                                  onChanged: (value) {
                                    item.price = num.parse(value);
                                  },
                                ),
                                const SizedBox(height: 20),
                                CategoriesForm(
                                  value: item.category?.isNotEmpty == true
                                      ? item.category![0]
                                      : "",
                                  cubit: StoreCubit(),
                                  onChanged: (value) {
                                    context.read<StoreCubit>().categoryValue =
                                        value;
                                  },
                                ),
                                const SizedBox(height: 20),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomCheckBox(
                                      title: 'موصى به',
                                      onChanged: (value) {
                                        item.isRecommended = value ?? false;
                                      },
                                    ),
                                    CustomCheckBox(
                                      title: 'شائع',
                                      onChanged: (value) {
                                        item.isPopular = value ?? false;
                                      },
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  initialValue: "${item.Quantity}",
                                  decoration: InputDecoration(
                                    labelText: "الكمية",
                                  ),
                                  onChanged: (value) {
                                    item.Quantity = int.parse(value);
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "إلغاء",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Call the method to update the item
                                  context
                                      .read<StoreCubit>()
                                      .updateStoreItem(item);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "تحديث",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class MyImageScrollWidget extends StatelessWidget {
  final List<String> imageUrls;

  const MyImageScrollWidget({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = ImageScrollCubit();
    final maxScrollExtent = (imageUrls.length * 78)
        .toDouble(); // Assuming each image is 70 wide with 8 spacing

    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<ImageScrollCubit, double>(
        builder: (context, scrollPosition) {
          final currentIndex =
              scrollPosition ~/ 78; // 78 is the width + spacing

          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: currentIndex > 0
                    ? () => cubit.scroll(ScrollDirection.left, maxScrollExtent)
                    : null,
              ),
              currentIndex < imageUrls.length
                  ? Image.network(
                imageUrls[currentIndex],
                width: 70,
                height: 70,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              )
                  : const SizedBox.shrink(),
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: currentIndex < imageUrls.length - 1
                    ? () => cubit.scroll(ScrollDirection.right, maxScrollExtent)
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
