import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solutech/controllers/activities_controller.dart';
import 'package:solutech/controllers/visits_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/activity.dart';


class Dashboard extends StatelessWidget {
  VisitsController visitsController = Get.find<VisitsController>();
  ActivitiesController activitiesController = Get.find<ActivitiesController>();
   Dashboard({super.key}){
     // visitsController.fetchVisits();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Obx(() {
        if (visitsController.visits.isEmpty) {
          return const Center(child: Text('No visits to display'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildStatusChart(),
              const SizedBox(height: 20),
              _buildActivityChart(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusChart() {
    final statusCounts = <String, int>{};
    for (var visit in visitsController.visits) {
      statusCounts[visit.status!] = (statusCounts[visit.status] ?? 0) + 1;
    }

    return SfCircularChart(
      title: ChartTitle(text: 'Visits by Status'),
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<MapEntry<String, int>, String>(
          dataSource: statusCounts.entries.toList(),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
  Widget _buildActivityChart() {
    final activityCounts = <String, int>{};
    for (var visit in visitsController.visits) {
      for (var activityId in visit.activitiesDone!) {
        final activity = activitiesController.activities.firstWhere(
              (a) => a.id.toString() == activityId,
          orElse: () => ActivityModel(
              id: 0, description: 'Unknown', createdAt: DateTime.now()),
        );
        activityCounts[activity.description!] =
            (activityCounts[activity.description] ?? 0) + 1;
      }
    }

    return SfCircularChart(
      title: ChartTitle(text: 'Activities Performed'),
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        DoughnutSeries<MapEntry<String, int>, String>(
          dataSource: activityCounts.entries.toList(),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}



