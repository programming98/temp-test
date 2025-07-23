import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:interview_project/bloc/sensor_bloc.dart';
import 'package:interview_project/bloc/sensor_bloc_event.dart';
import 'package:interview_project/model/sensor.dart';

class EditSensorPage extends StatefulWidget {
  final Sensor sensor;

  const EditSensorPage({super.key, required this.sensor});

  @override
  State<EditSensorPage> createState() => _EditSensorPageState();
}

class _EditSensorPageState extends State<EditSensorPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sensor.name);
    _descriptionController = TextEditingController(
      text: widget.sensor.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'sensor_name'.tr()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'name_required'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'description'.tr(),
                  alignLabelWithHint: true,
                ),
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'description_required'.tr();
                  }
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedSensor = widget.sensor.copyWith(
                        name: _nameController.text.trim(),
                        description: _descriptionController.text.trim(),
                      );

                      context.read<SensorBloc>().add(
                        UpdateSensorEvent(updatedSensor),
                      );

                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('sensor_updated'.tr()),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'save'.tr(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
