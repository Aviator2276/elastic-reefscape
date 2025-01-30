import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elastic_dashboard/widgets/nt_widgets/nt_widget.dart';
import 'package:dot_cast/dot_cast.dart';

class ReefModel extends SingleTopicNTWidgetModel {
  @override
  String type = 'Reef';

  ReefModel({
    required super.ntConnection,
    required super.preferences,
    required super.topic,
    super.dataType,
    super.period,
  });

  ReefModel.fromJson({
    required super.ntConnection,
    required super.preferences,
    required Map<String, dynamic> jsonData,
  }) : super.fromJson(jsonData: jsonData);

  @override
  List<Widget> getEditProperties(BuildContext context) {
    // Add any configurable properties here.  For example,
    // if you wanted the user to configure the number of slots:
    /*
    return [
       DialogTextInput(
          label: 'Number of Slots',
          initialText: numSlots.toString(),
          onSubmit: (value) {
             int? newValue = int.tryParse(value);
             if (newValue != null) {
                numSlots = newValue;
             }
          },
        ),
    ];
    */
    return []; // Return an empty list if no configurable properties
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Edit properties to configure number of slots');
  }
}

class Reef extends NTWidget {
  static const String widgetType = 'Reef';

  const Reef({super.key});

  @override
  Widget build(BuildContext context) {
    ReefModel model = cast(context.watch<NTWidgetModel>());

    return ListenableBuilder(
      listenable: model.subscription, // Rebuild when data changes
      builder: (context, child) {
        // Get the data from NetworkTables
        List<Object?>? slotDataRaw =
            model.subscription.value?.tryCast<List<Object?>>();
        List<bool> slotData = [];

        if (slotDataRaw != null) {
          slotData = slotDataRaw.whereType<bool>().toList();
        }

        if (slotData.isEmpty) {
          slotData = List.generate(
              10,
              (index) =>
                  false); // Replace 10 with your default or configured number of slots
        }

        int numSlots = slotData.length;

        return Column(
          children: [
            for (int i = 0; i < numSlots; i++)
              Row(
                children: [
                  Text('Slot ${i + 1}: '),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: slotData[i] ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
