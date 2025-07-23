import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:interview_project/bloc/sensor_bloc_event.dart';
import 'package:interview_project/bloc/sensor_bloc_state.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';

class SensorBloc extends Bloc<SensorBlocEvent, SensorBlocState> {
  final SensorRepository _repository = SensorRepository();

  SensorBloc() : super(SensorBlocInitialState()) {
    on<InitializeSensorEvent>(_initializeSensors);
    on<UpdateSensorEvent>(_updateSensor);
    on<SearchSensorsEvent>(_searchSensors);
    on<ClearSearchEvent>(_clearSearch);

    add(InitializeSensorEvent());
  }

  Future<void> _initializeSensors(
    InitializeSensorEvent event,
    Emitter<SensorBlocState> emit,
  ) async {
    emit(SensorBlocLoadingState());

    try {
      _repository.initializeSensors();

      await emit.forEach<List<Sensor>>(
        _repository.sensorsStream,
        onData: (sensors) {
          if (state is SensorBlocLoadedState) {
            final currentState = state as SensorBlocLoadedState;
            final filteredSensors = _filter(sensors, currentState.searchQuery);
            return currentState.copyWith(
              sensors: sensors,
              filteredSensors: filteredSensors,
            );
          }
          return SensorBlocLoadedState(sensors: sensors);
        },
        onError: (error, stackTrace) {
          return SensorBlocErrorState('error_load'.tr());
        },
      );
    } catch (e) {
      emit(SensorBlocErrorState('error_init'.tr()));
    }
  }

  void _updateSensor(UpdateSensorEvent event, Emitter<SensorBlocState> emit) {
    _repository.updateSensor(event.sensor);
  }

  void _searchSensors(SearchSensorsEvent event, Emitter<SensorBlocState> emit) {
    if (state is SensorBlocLoadedState) {
      final currentState = state as SensorBlocLoadedState;
      final filteredSensors = _filter(currentState.sensors, event.query);
      emit(
        currentState.copyWith(
          searchQuery: event.query,
          filteredSensors: filteredSensors,
        ),
      );
    }
  }

  void _clearSearch(ClearSearchEvent event, Emitter<SensorBlocState> emit) {
    if (state is SensorBlocLoadedState) {
      final currentState = state as SensorBlocLoadedState;
      emit(
        currentState.copyWith(
          searchQuery: '',
          filteredSensors: currentState.sensors,
        ),
      );
    }
  }

  List<Sensor> _filter(List<Sensor> sensors, String query) {
    if (query.isEmpty) return sensors;

    final lowerQuery = query.toLowerCase();
    return sensors.where((sensor) {
      return sensor.name.toLowerCase().contains(lowerQuery) ||
          sensor.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
