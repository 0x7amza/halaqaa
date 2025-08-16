import 'dart:typed_data';

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/core/BLoC/DropDown/drop_down_bloc.dart'
    hide DropDownState;
import 'package:halaqaa/core/utils/functions.utils.dart';

Widget textField({
  required String hintText,
  height = 50.0,
  isHintCentered = true,
  title = '',
  required controller,
  TextInputType keyboardType = TextInputType.multiline,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(height: 5.0),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        height: height.toDouble(),
        child: TextField(
          controller: controller,
          expands: true,
          maxLines: null,

          keyboardType: keyboardType,
          textAlignVertical: isHintCentered
              ? TextAlignVertical.center
              : TextAlignVertical.top,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    ],
  );
}

class dropDwon extends StatelessWidget {
  final List<String> items;
  final String value;
  final String title;
  final onTap;

  const dropDwon({
    super.key,
    required this.items,
    required this.value,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DropDownBloc()..add(DropDownLoadEvent(selectedValue: value)),
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () {
                    DropDownState<String>(
                      dropDown: DropDown<String>(
                        data: items
                            .map((item) => SelectedListItem<String>(data: item))
                            .toList(),
                        onSelected: (selectedItems) {
                          if (selectedItems.isNotEmpty) {
                            final selected = selectedItems.first;
                            context.read<DropDownBloc>().add(
                              DropDownLoadEvent(
                                selectedValue: selected.data ?? '',
                              ),
                            );
                            onTap(selected.data);
                          }
                        },
                      ),
                    ).showModal(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: BlocBuilder<DropDownBloc, BlocDropDownState>(
                            builder: (context, state) {
                              if (state is DropDownLoaded &&
                                  state.selectedValue.isNotEmpty) {
                                return Text(
                                  state.selectedValue,
                                  style: const TextStyle(fontSize: 16),
                                );
                              }
                              return const Text(
                                "-",
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CompressedQRView extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const CompressedQRView({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: generateCompressedQR(studentData),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
