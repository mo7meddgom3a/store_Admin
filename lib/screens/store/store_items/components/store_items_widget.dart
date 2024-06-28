import 'package:anwer_shop_admin/constants.dart';
import 'package:anwer_shop_admin/loader/loading_indicator.dart';
import 'package:anwer_shop_admin/screens/store/categoris/cubit/categories_cubit.dart';
import 'package:anwer_shop_admin/screens/store/store_items/cubit/add_store_item_cubit.dart';
import 'package:anwer_shop_admin/screens/store/store_items/cubit/store_cubit.dart';
import 'package:anwer_shop_admin/screens/store/store_items/cubit/store_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/scrol_cubit.dart';
import '../widgets/categories_form.dart';
import '../widgets/custom_check_box_widget.dart';

class StoreItemsWidget extends StatelessWidget {
  StoreItemsWidget({super.key});
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<StoreCubit>().loadStoreItems();
    context.read<CategoriesCubit>().loadCategoriesNames();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Text(
            "العناصر في المتجر",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _searchController,
            textAlign: TextAlign.right, // Align text to the right
            textDirection: TextDirection.rtl, // Set text direction to right-to-left
            decoration: InputDecoration(
              labelText: 'بحث عن منتج',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              context.read<StoreCubit>().searchStoreItems(value.toLowerCase());
            },
          ),
        ),
        SizedBox(height: defaultPadding),
        BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            if (state is StoreLoading) {
              return Center(
                child: loadingIndicator(
                  color: Colors.white,
                ),
              );
            } else if (state is StoreLoaded) {
              return SizedBox(
                width: double.infinity,
                child: DataTable(
                  horizontalMargin: 50,
                  dataRowMinHeight: 100,
                  dataRowMaxHeight: 200,
                  columns: [
                    DataColumn(label: Text("صورة المنتج")),
                    DataColumn(label: Text("اسم المنتج")),
                    DataColumn(label: Text("الفئة")),
                    DataColumn(label: Text("الكمية")),
                    DataColumn(label: Text("سعر المنتج")),
                    DataColumn(label: Text("الإجراءات")),
                  ],
                  rows: List.generate(
                    state.filteredItems.length,
                        (index) => foundDataRow(state.filteredItems[index]),
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
                              content:
                              Text("هل أنت متأكد أنك تريد حذف هذه الفئة؟"),
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
                                SizedBox(height: 20),
                                // add images
                                BlocBuilder<StoreCubit,
                                    StoreState>(
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<StoreCubit>()
                                                .uploadImages();
                                          },
                                          child: Text("تحميل الصور"),
                                        ),
                                        const SizedBox(height: 20),
                                        if (state.image != null && state.image!.isNotEmpty)
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: state.image!.map((image) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.1),
                                                          blurRadius: 5,
                                                          offset: Offset(0, 5),
                                                        ),
                                                      ],
                                                      border: Border.all(color: Colors.grey, width: 1),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.memory(
                                                        image,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return const SizedBox.shrink();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 4,
                                                    right: 4,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        context.read<StoreCubit>().removeImage(
                                                          context.read<StoreCubit>().state.image!.indexOf(image),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        padding: EdgeInsets.all(4),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        if (state is StoreLoading)
                                          Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        const SizedBox(height: 20),
                                        Text("الصور الحالية"),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 100,
                                          width: 200,
                                          child: GestureDetector(
                                            onHorizontalDragUpdate: (details) {
                                              _scrollController.jumpTo(
                                                _scrollController.offset -
                                                    details.delta.dx,
                                              );
                                            },
                                            child: Scrollbar(
                                              controller: _scrollController,
                                              thumbVisibility: true,
                                              child: ListView.builder(
                                                controller: _scrollController,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: item.imageUrl.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.1),
                                                                blurRadius: 5,
                                                                offset: Offset(0, 5),
                                                              ),
                                                            ],
                                                            border: Border.all(color: Colors.grey, width: 1),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(8),
                                                            child: Image.network(
                                                              item.imageUrl[index],
                                                              width: 100,
                                                              height: 100,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return const SizedBox.shrink();
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 4,
                                                          right: 4,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return AlertDialog(
                                                                    title: Text("حذف الصورة"),
                                                                    content: Text("هل أنت متأكد أنك تريد حذف هذه الصورة من المتجر؟"),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Text("إلغاء"),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed: () async{
                                                                          await context.read<StoreCubit>().removeImageFromFireStore(
                                                                            item.documentId,
                                                                            item.imageUrl[index],
                                                                          );
                                                                          Navigator.pop(context);
                                                                          context.read<StoreCubit>().loadStoreItems();
                                                                          item.imageUrl.removeAt(index);

                                                                        },
                                                                        child: Text("حذف"),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );

                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                shape: BoxShape.circle,
                                                              ),
                                                              padding: EdgeInsets.all(4),
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors.white,
                                                                size: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                // display the current images
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
                                onPressed: () async{
                                  // Call the method to update the item
                                  await context
                                      .read<StoreCubit>()
                                      .updateStoreItem(item);

                                  // await context.read<StoreCubit>().addImagesToCurrentImagesFirestore(item.documentId);

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
                  ? InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        //scrollable with all images
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i < imageUrls.length; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 38.0),
                                  child: Image.network(
                                    imageUrls[i],
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Image.network(
                  imageUrls[currentIndex],
                  width: 70,
                  height: 70,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
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
