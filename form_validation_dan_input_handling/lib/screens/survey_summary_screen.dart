import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/survey.dart';
import 'survey_screen.dart';

class SurveySummaryScreen extends StatefulWidget {
  const SurveySummaryScreen({Key? key}) : super(key: key);

  @override
  _SurveySummaryScreenState createState() => _SurveySummaryScreenState();
}

class _SurveySummaryScreenState extends State<SurveySummaryScreen> {
  List<Survey> _surveys = [];

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  Future<void> _loadSurveys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSurvey = prefs.getString('last_survey');

      if (lastSurvey != null) {
        final survey = Survey.fromJson(json.decode(lastSurvey));
        setState(() {
          _surveys = [survey];
        });
      }
    } catch (e) {
      print('Error loading surveys: $e');
    }
  }

  Widget _buildSurveyCard(Survey survey) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Survey',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Nama', survey.name),
            _buildInfoRow('Umur', '${survey.age} tahun'),
            _buildInfoRow('Pekerjaan', survey.occupation),
            const SizedBox(height: 8),
            _buildInfoRow('Minat', survey.interests.join(', ')),
            _buildInfoRow(
                'Tingkat Kepuasan', _getSatisfactionLabel(survey.satisfaction)),
            const SizedBox(height: 8),
            const Text(
              'Feedback:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(survey.feedback),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: Colors.green,
                  label: Text(
                    'Total: ${_calculateScore(survey)} poin',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  'Dibuat: ${_formatDate(DateTime.now())}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getSatisfactionLabel(int satisfaction) {
    final labels = [
      'Sangat Tidak Puas',
      'Tidak Puas',
      'Cukup Puas',
      'Puas',
      'Sangat Puas'
    ];
    return labels[satisfaction - 1];
  }

  int _calculateScore(Survey survey) {
    int score = survey.satisfaction * 2;
    score += survey.interests.length;
    if (survey.feedback.length > 10) score += 3;
    return score;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Survey'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _surveys.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada survey',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SurveyScreen()),
                      );
                    },
                    child: const Text('Isi Survey Sekarang'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _surveys.length,
              itemBuilder: (context, index) {
                return _buildSurveyCard(_surveys[index]);
              },
            ),
    );
  }
}
