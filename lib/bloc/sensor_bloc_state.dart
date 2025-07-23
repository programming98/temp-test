import 'package:equatable/equatable.dart';
import 'package:interview_project/model/sensor.dart';

sealed class SensorBlocState extends Equatable {}

class SensorBlocInitialState extends SensorBlocState {
  @override
  List<Object?> get props => [];
}

class SensorBlocLoadingState extends SensorBlocState {
  @override
  List<Object?> get props => [];
}

class SensorBlocLoadedState extends SensorBlocState {
  final List<Sensor> sensors;
  final List<Sensor> filteredSensors;
  final String searchQuery;

  SensorBlocLoadedState({
    required this.sensors,
    List<Sensor>? filteredSensors,
    this.searchQuery = '',
  }) : filteredSensors = filteredSensors ?? sensors;

  @override
  List<Object?> get props => [sensors, filteredSensors, searchQuery];

  SensorBlocLoadedState copyWith({
    List<Sensor>? sensors,
    List<Sensor>? filteredSensors,
    String? searchQuery,
  }) {
    return SensorBlocLoadedState(
      sensors: sensors ?? this.sensors,
      filteredSensors: filteredSensors ?? this.filteredSensors,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class SensorBlocErrorState extends SensorBlocState {
  final String message;

  SensorBlocErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
