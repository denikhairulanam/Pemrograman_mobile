import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/survey.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_button.dart';
import 'survey_summary_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  final _feedbackController = TextEditingController();

  int _currentStep = 0;
  List<String> _selectedInterests = [];
  int _satisfactionLevel = 3;
  bool _isSubmitting = false;

  final List<String> _interests = [
    'Teknologi',
    'Olahraga',
    'Musik',
    'Seni',
    'Travel',
    'Kuliner',
    'Baca',
    'Game'
  ];

  final List<String> _satisfactionLabels = [
    'Sangat Tidak Puas',
    'Tidak Puas',
    'Cukup Puas',
    'Puas',
    'Sangat Puas'
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedSurvey();
  }

  Future<void> _loadSavedSurvey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final surveyData = prefs.getString('current_survey');

      if (surveyData != null) {
        final survey = Survey.fromJson(json.decode(surveyData));

        setState(() {
          _nameController.text = survey.name;
          _ageController.text = survey.age.toString();
          _occupationController.text = survey.occupation;
          _selectedInterests = List<String>.from(survey.interests);
          _satisfactionLevel = survey.satisfaction;
          _feedbackController.text = survey.feedback;
        });
      }
    } catch (e) {
      print('Error loading survey: $e');
    }
  }

  Future<void> _saveSurveyProgress() async {
    final survey = Survey(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      occupation: _occupationController.text,
      interests: _selectedInterests,
      satisfaction: _satisfactionLevel,
      feedback: _feedbackController.text,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_survey', json.encode(survey.toJson()));
  }

  bool _validateStep1() {
    return _nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _occupationController.text.isNotEmpty;
  }

  bool _validateStep2() {
    return _selectedInterests.isNotEmpty;
  }

  void _nextStep() {
    if (_currentStep == 0 && !_validateStep1()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data responden')),
      );
      return;
    }

    if (_currentStep == 1 && !_validateStep2()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih minimal 1 interest')),
      );
      return;
    }

    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitSurvey() async {
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    try {
      final survey = Survey(
        name: _nameController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        occupation: _occupationController.text,
        interests: _selectedInterests,
        satisfaction: _satisfactionLevel,
        feedback: _feedbackController.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_survey', json.encode(survey.toJson()));
      await prefs.remove('current_survey');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Survey berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to summary screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SurveySummaryScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan survey: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _currentStep
                  ? Colors.blue
                  : index < _currentStep
                      ? Colors.green
                      : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Data Responden',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _nameController,
            label: 'Nama Lengkap',
            validator: Validators.validateName,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _ageController,
            label: 'Umur',
            keyboardType: TextInputType.number,
            validator: Validators.validateAge,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _occupationController,
            label: 'Pekerjaan',
            validator: (value) =>
                Validators.validateRequired(value, 'Pekerjaan'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Minat dan Kepuasan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          const Text(
            'Pilih minat Anda:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                  _saveSurveyProgress();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            'Tingkat Kepuasan:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _satisfactionLevel.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: _satisfactionLabels[_satisfactionLevel - 1],
            onChanged: (value) {
              setState(() {
                _satisfactionLevel = value.round();
              });
              _saveSurveyProgress();
            },
          ),
          Text(
            _satisfactionLabels[_satisfactionLevel - 1],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Feedback',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _feedbackController,
            label: 'Masukan dan Saran',
            maxLines: 5,
            validator: (value) =>
                Validators.validateRequired(value, 'Feedback'),
          ),
          const SizedBox(height: 32),
          const Text(
            'Ringkasan Survey:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${_nameController.text}'),
            Text('Umur: ${_ageController.text} tahun'),
            Text('Pekerjaan: ${_occupationController.text}'),
            const SizedBox(height: 8),
            Text('Minat: ${_selectedInterests.join(", ")}'),
            Text('Kepuasan: ${_satisfactionLabels[_satisfactionLevel - 1]}'),
            const SizedBox(height: 8),
            const Text('Feedback:'),
            Text(_feedbackController.text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Kembali'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _currentStep == 2
                      ? LoadingButton(
                          onPressed: _submitSurvey,
                          text: 'Submit Survey',
                          isLoading: _isSubmitting,
                          color: Colors.green,
                        )
                      : ElevatedButton(
                          onPressed: _nextStep,
                          child: const Text('Lanjut'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
