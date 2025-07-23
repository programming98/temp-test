import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:interview_project/bloc/sensor_bloc.dart';
import 'package:interview_project/bloc/sensor_bloc_event.dart';
import 'package:interview_project/bloc/sensor_bloc_state.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/widget/edit_sensor_page.dart';

class SensorListPage extends StatefulWidget {
  const SensorListPage({super.key});

  @override
  State<SensorListPage> createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SensorBloc>().add(ClearSearchEvent());
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                context.read<SensorBloc>().add(SearchSensorsEvent(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SensorBloc, SensorBlocState>(
              builder: (context, state) {
                if (state is SensorBlocLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SensorBlocErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SensorBloc>().add(
                              InitializeSensorEvent(),
                            );
                          },
                          child: Text('retry'.tr()),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SensorBlocLoadedState) {
                  final sensors = state.filteredSensors;

                  if (sensors.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.not_accessible,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.searchQuery.isNotEmpty
                                ? 'no_results'.tr(
                                    namedArgs: {'query': state.searchQuery},
                                  )
                                : 'no_sensors'.tr(),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: sensors.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final sensor = sensors[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            sensor.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            sensor.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${sensor.value.toStringAsFixed(1)}°F',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onTap: () => _navigateToEditPage(context, sensor),
                        ),
                      );
                    },
                  );
                }

                return Center(child: Text('loading'.tr()));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, Sensor sensor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<SensorBloc>(),
          child: EditSensorPage(sensor: sensor),
        ),
      ),
    );
  }
}
