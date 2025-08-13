// screens/inspection_form_screen.dart
import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:appregdatainspect/core/providers/references_provider.dart';
import 'package:appregdatainspect/models/reference_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class InspectionFormScreen extends StatefulWidget {
  final Reference reference;

  const InspectionFormScreen({super.key, required this.reference});

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  late Reference _editedReference;
  final _formKey = GlobalKey<FormState>();
  final _temperatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedReference = widget.reference.copyWith();
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Text('Inspección #${_editedReference.reference}'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildReleaseSection(),
              const SizedBox(height: 24),
              _buildSamplingSection(),
              const SizedBox(height: 24),
              _buildStampingSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReleaseSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.play_circle_outline, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Liberación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDateTimeRow(
              icon: Icons.timer,
              label: 'Inicio Liberación',
              date: _editedReference.releaseStartDate,
              time: _editedReference.releaseStartTime,
              onDateChanged: (date) => setState(() {
                _editedReference = _editedReference.copyWith(
                  releaseStartDate: date,
                );
              }),
              onTimeChanged: (time) => setState(() {
                _editedReference = _editedReference.copyWith(
                  releaseStartTime: time,
                );
              }),
            ),
            const SizedBox(height: 16),
            _buildDateTimeRow(
              icon: Icons.timer_off,
              label: 'Fin Liberación',
              date: _editedReference.releaseFinishDate,
              time: _editedReference.releaseFinishTime,
              onDateChanged: (date) => setState(() {
                _editedReference = _editedReference.copyWith(
                  releaseFinishDate: date,
                );
              }),
              onTimeChanged: (time) => setState(() {
                _editedReference = _editedReference.copyWith(
                  releaseFinishTime: time,
                );
              }),
            ),
            const SizedBox(height: 16),
            /* _buildTemperatureField(
              icon: Icons.thermostat,
              label: 'Temperatura Liberación (°C)',
              value: _editedReference.releaseTemperature,
              onChanged: (value) => setState(() {
                _editedReference = _editedReference.copyWith(
                  releaseTemperature: double.tryParse(value),
                );
              }),
            ), */
            _buildTemperatureField(
              icon: Icons.thermostat,
              label: 'Temperatura Liberación (°C)',
              value: _editedReference.releaseTemperature,
              onChanged: (value) {
                final temp = double.tryParse(value);
                setState(
                  () => _editedReference = _editedReference.copyWith(
                    releaseTemperature: temp,
                  ),
                );
              },
              isRequired: _editedReference.releaseFinishDate != null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSamplingSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science_outlined, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Muestreo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDateTimeRow(
              icon: Icons.timer,
              label: 'Inicio Muestreo',
              date: _editedReference.sampleStartDate,
              time: _editedReference.sampleStartTime,
              onDateChanged: (date) => setState(() {
                _editedReference = _editedReference.copyWith(
                  sampleStartDate: date,
                );
              }),
              onTimeChanged: (time) => setState(() {
                _editedReference = _editedReference.copyWith(
                  sampleStartTime: time,
                );
              }),
            ),
            const SizedBox(height: 16),
            _buildDateTimeRow(
              icon: Icons.timer_off,
              label: 'Fin Muestreo',
              date: _editedReference.sampleFinishDate,
              time: _editedReference.sampleFinishTime,
              onDateChanged: (date) => setState(() {
                _editedReference = _editedReference.copyWith(
                  sampleFinishDate: date,
                );
              }),
              onTimeChanged: (time) => setState(() {
                _editedReference = _editedReference.copyWith(
                  sampleFinishTime: time,
                );
              }),
            ),
            const SizedBox(height: 16),
            /*  _buildTemperatureField(
              icon: Icons.thermostat,
              label: 'Temperatura Muestreo (°C)',
              value: _editedReference.sampleTemperature,
              onChanged: (value) => setState(() {
                _editedReference = _editedReference.copyWith(
                  sampleTemperature: double.tryParse(value),
                );
              }),
            ), */
            _buildTemperatureField(
              icon: Icons.thermostat,
              label: 'Temperatura Muestreo (°C)',
              value: _editedReference.sampleTemperature,
              onChanged: (value) {
                final temp = double.tryParse(value);
                setState(
                  () => _editedReference = _editedReference.copyWith(
                    sampleTemperature: temp,
                  ),
                );
              },
              isRequired: _editedReference.sampleFinishDate != null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStampingSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.soap_outlined, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Sellado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDateTimeRow(
              icon: Icons.calendar_today,
              label: 'Fecha Sellado',
              date: _editedReference.stampedDate,
              time: _editedReference.stampedTime,
              onDateChanged: (date) => setState(() {
                _editedReference = _editedReference.copyWith(stampedDate: date);
              }),
              onTimeChanged: (time) => setState(() {
                _editedReference = _editedReference.copyWith(stampedTime: time);
              }),
            ),
            const SizedBox(height: 16),
            /* _buildTemperatureField(
              icon: Icons.thermostat,
              label: 'Temperatura Sellado (°C)',
              value: _editedReference.stampedTemperature,
              onChanged: (value) => setState(() {
                _editedReference = _editedReference.copyWith(
                  stampedTemperature: double.tryParse(value),
                );
              }),
            ), */
            _buildTemperatureField(
              icon: Icons.thermostat,
              label: 'Temperatura Sellado (°C)',
              value: _editedReference.stampedTemperature,
              onChanged: (value) {
                final temp = double.tryParse(value);
                setState(
                  () => _editedReference = _editedReference.copyWith(
                    stampedTemperature: temp,
                  ),
                );
              },
              isRequired: _editedReference.stampedDate != null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeRow({
    required IconData icon,
    required String label,
    required DateTime? date,
    required String? time,
    required Function(DateTime?) onDateChanged,
    required Function(String?) onTimeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.darkGray),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  onDateChanged(selectedDate);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(
                    date != null
                        ? DateFormat('dd/MM/yyyy').format(date)
                        : 'Seleccionar fecha',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: time != null
                        ? TimeOfDay(
                            hour: int.parse(time.split(':')[0]),
                            minute: int.parse(time.split(':')[1]),
                          )
                        : TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    onTimeChanged(
                      '${selectedTime.hour.toString().padLeft(2, '0')}:'
                      '${selectedTime.minute.toString().padLeft(2, '0')}',
                    );
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.access_time),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(time ?? 'Seleccionar hora'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemperatureField({
    required IconData icon,
    required String label,
    required double? value,
    required Function(String) onChanged,
    required bool isRequired, // Nuevo parámetro
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.darkGray),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            if (isRequired)
              const Text('*', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value?.toString() ?? '',
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          decoration: InputDecoration(
            suffixText: '°C',
            border: const OutlineInputBorder(),
            hintText: 'Ej: 10.20, -23, 35',
            errorMaxLines: 2,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}')),
          ],
          onChanged: onChanged,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  final temp = double.tryParse(value);
                  if (temp == null) return 'Valor numérico inválido';
                  if (temp < -273.15) return 'No puede ser < -273.15°C';
                  if (temp > 1000) return 'Valor demasiado alto';
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _saveForm,
      child: const Text(
        'GUARDAR INSPECCIÓN',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  void _saveForm() async {
    // Validar reglas condicionales primero
    final validationErrors = _validateForm();
    if (validationErrors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationErrors.join('\n')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<ReferencesProvider>(context, listen: false);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Guardar localmente primero (incluso si no está completo)
      await provider.updateReference(_editedReference);

      // Intentar sincronizar con la API solo si hay conexión y datos válidos
      final success = await provider.syncReferenceWithApi(_editedReference);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (success) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, _editedReference.copyWith(isSynced: true));
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Datos guardados localmente (pendientes de sincronización)',
            ),
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<String> _validateForm() {
    final errors = <String>[];

    // Validación para Liberación
    if (_editedReference.releaseStartDate != null &&
        _editedReference.releaseStartTime == null) {
      errors.add('Debe seleccionar una hora de inicio de liberación');
    }

    if (_editedReference.releaseFinishDate != null) {
      if (_editedReference.releaseFinishTime == null) {
        errors.add('Debe seleccionar una hora de fin de liberación');
      }
      if (_editedReference.releaseTemperature == null) {
        errors.add('Debe ingresar la temperatura de liberación');
      }
    }

    // Validación para Muestreo
    if (_editedReference.sampleStartDate != null &&
        _editedReference.sampleStartTime == null) {
      errors.add('Debe seleccionar una hora de inicio de muestreo');
    }

    if (_editedReference.sampleFinishDate != null) {
      if (_editedReference.sampleFinishTime == null) {
        errors.add('Debe seleccionar una hora de fin de muestreo');
      }
      if (_editedReference.sampleTemperature == null) {
        errors.add('Debe ingresar la temperatura de muestreo');
      }
    }

    // Validación para Sellado
    if (_editedReference.stampedDate != null) {
      if (_editedReference.stampedTime == null) {
        errors.add('Debe seleccionar una hora de sellado');
      }
      if (_editedReference.stampedTemperature == null) {
        errors.add('Debe ingresar la temperatura de sellado');
      }
    }

    return errors;
  }
}
