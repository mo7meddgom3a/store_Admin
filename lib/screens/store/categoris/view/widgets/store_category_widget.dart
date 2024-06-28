import 'package:anwer_shop_admin/constants.dart';
import 'package:anwer_shop_admin/loader/loading_indicator.dart';
import 'package:anwer_shop_admin/screens/store/categoris/cubit/categories_cubit.dart';
import 'package:anwer_shop_admin/screens/store/categoris/cubit/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreCategoryItems extends StatelessWidget {
  const StoreCategoryItems({Key? key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoriesCubit>().loadCategoriesItems();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Text(
            "فئات المتجر",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return Center(
                child: loadingIndicator(
                  color: Colors.white,
                ),
              );
            } else if (state is CategoriesLoaded) {
              return SizedBox(
                width: double.infinity,
                child: DataTable(
                  horizontalMargin: 50,
                  dataRowMinHeight: 100,
                  dataRowMaxHeight: 200,
                  columns: [
                    DataColumn(
                      label: Text("صورة العنصر"),
                    ),
                    DataColumn(
                      label: Text("الفئة"),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("الإجراءات"),
                          ],
                        ),
                      ),
                    ),
                  ],
                  rows: List.generate(
                    state.items.length,
                    (index) => foundDataRow(state.items[index], state, context),
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

  DataRow foundDataRow(
      CategoriesItem item, CategoriesState state, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    content: Image.network(item.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    }),
                  );
                },
              );
            },
            child: Image.network(item.imageUrl, width: 100, height: 100,
                errorBuilder: (context, error, stackTrace) {
              return SizedBox.shrink();
            }),
          ),
        ),
        DataCell(Text(item.category)),
        DataCell(
          state is CategoriesLoading
              ? Center(
                  child: loadingIndicator(
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                                  "هل أنت متأكد من رغبتك في حذف هذه الفئة؟"),
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
                                  child: Text(
                                    "إلغاء",
                                    style: TextStyle(color: Colors.white),
                                  ),
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
                                        .read<CategoriesCubit>()
                                        .deleteCategoryItem(item.documentId);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "حذف",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return EditCategoryDialog(item: item);
                          },
                        );
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class EditCategoryDialog extends StatelessWidget {
  final CategoriesItem item;

  const EditCategoryDialog({Key? key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("تعديل الفئة"),
      content: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: item.category,
                decoration: InputDecoration(
                  labelText: "اسم الفئة",
                ),
                onChanged: (value) {
                  item.category = value;
                },
              ),
              SizedBox(
                height: defaultPadding,
              ),
              ElevatedButton(
                onPressed: () async {
                  await context.read<CategoriesCubit>().uploadImage();
                },
                child: Text("تحديث الصورة"),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              if (state.image != null && state.image!.isNotEmpty &&state.image != Uint8List(0))
                Stack(
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
                        child: state.image != null
                            ? Image.memory(state.image!,
                                width: 100, height: 100, fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              })
                            : Container(),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          context.read<CategoriesCubit>().removeImage();
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

              // display current image
              Image.network(item.imageUrl, width: 100, height: 100,
                  errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              }),
            ],
          );
        },
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
            context.read<CategoriesCubit>().updateCategoryItem(item);
            Navigator.pop(context);
          },
          child: Text(
            "تحديث",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
