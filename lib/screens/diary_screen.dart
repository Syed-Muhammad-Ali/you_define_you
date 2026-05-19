import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/theme.dart';
import '../models/app_state.dart';
import '../widgets/widgets.dart';

class ThoughtDiaryScreen extends StatefulWidget {
  const ThoughtDiaryScreen({super.key});
  @override State<ThoughtDiaryScreen> createState() => _ThoughtDiaryScreenState();
}

class _ThoughtDiaryScreenState extends State<ThoughtDiaryScreen> {
  bool _showEntry = false;

  @override
  Widget build(BuildContext context) {
    if (_showEntry) return _DiaryEntryForm(onBack: () => setState(() => _showEntry = false));

    final appState = context.watch<AppState>();
    final entries = appState.diaryEntries;

    return Scaffold(
      backgroundColor: YDYColors.black,
      body: Column(
        children: [
          ScreenHeader(stepLabel: 'Daily Tool', title: 'Thought Diary', onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YDYCard(
                    child: Text(
                      'Every night before bed, 5 minutes. Score your day, write what happened, name the thought that\'s sitting heaviest. Do it for 7 nights and you\'ll see patterns you couldn\'t see before.',
                      style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.65),
                    ),
                  ),
                  const SizedBox(height: 20),
                  YDYButton(
                    label: "TONIGHT'S ENTRY →",
                    onTap: () => setState(() => _showEntry = true),
                  ),
                  if (entries.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text('PREVIOUS ENTRIES', style: YDYTypography.bebasNeue(fontSize: 14, color: YDYColors.muted, letterSpacing: 2)),
                    const SizedBox(height: 12),
                    ...entries.map((entry) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: YDYColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: YDYColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry['date'] ?? '', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted)),
                              _ScoreBadge(score: entry['score'] ?? 5),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(entry['summary'] ?? '', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.white, height: 1.55, fontWeight: FontWeight.w300)),
                          if (entry['thought'] != null && (entry['thought'] as String).isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: YDYColors.orangeDim,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(entry['thought'], style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.orange, fontStyle: FontStyle.italic)),
                            ),
                          ],
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  const _ScoreBadge({required this.score});

  Color get _color {
    if (score >= 8) return YDYColors.green;
    if (score >= 5) return YDYColors.orange;
    return YDYColors.red;
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _color.withValues(alpha: 0.4)),
    ),
    child: Text('$score/10', style: YDYTypography.bebasNeue(fontSize: 14, color: _color)),
  );
}

class _DiaryEntryForm extends StatefulWidget {
  final VoidCallback onBack;
  const _DiaryEntryForm({required this.onBack});
  @override State<_DiaryEntryForm> createState() => _DiaryEntryFormState();
}

class _DiaryEntryFormState extends State<_DiaryEntryForm> {
  int? _score;
  final _summaryCtrl = TextEditingController();
  final _thoughtCtrl = TextEditingController();
  bool _saving = false;

  bool get _canSave => _score != null && _summaryCtrl.text.trim().isNotEmpty;

  Future<void> _saveEntry() async {
    if (!_canSave || _saving) return;
    setState(() => _saving = true);
    try {
      await context.read<AppState>().addDiaryEntry({
        'date': DateFormat('d MMM').format(DateTime.now()),
        'score': _score,
        'summary': _summaryCtrl.text.trim(),
        'thought': _thoughtCtrl.text.trim(),
        'ts': DateTime.now().millisecondsSinceEpoch,
      });
      if (!mounted) return;
      widget.onBack();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save your diary entry right now. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: YDYLoadingOverlay(
        loading: _saving,
        message: 'Saving tonight\'s entry...',
        child: Column(
          children: [
            ScreenHeader(stepLabel: 'New Entry', title: "Tonight's Diary", onBack: widget.onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('EEEE d MMMM').format(DateTime.now()),
                      style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted)),
                    const SizedBox(height: 20),
                    Text('Score your day 1–10', style: YDYTypography.dmSans(fontSize: 15, color: YDYColors.white, fontWeight: FontWeight.w500)),
                    Text('Your gut number. Don\'t overthink it.', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted)),
                    const SizedBox(height: 12),
                    ScoreDots(selected: _score, onSelect: (s) => setState(() => _score = s)),
                    const SizedBox(height: 24),
                    Text('What happened today?', style: YDYTypography.dmSans(fontSize: 15, color: YDYColors.white, fontWeight: FontWeight.w500)),
                    Text('2–3 honest sentences. Raw is better than polished.', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _summaryCtrl,
                      maxLines: 4,
                      style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white),
                      decoration: const InputDecoration(hintText: 'What happened, what you felt, what shaped the day...'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                    Text("Tonight's heaviest thought", style: YDYTypography.dmSans(fontSize: 15, color: YDYColors.white, fontWeight: FontWeight.w500)),
                    Text("The one thing that's sitting with you. Park it here so your brain can rest.", style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _thoughtCtrl,
                      maxLines: 3,
                      style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white),
                      decoration: const InputDecoration(hintText: "Optional — but getting it out breaks the loop"),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: YDYButton(
                label: 'SAVE TONIGHT\'S ENTRY →',
                enabled: _canSave && !_saving,
                loading: _saving,
                onTap: _canSave ? _saveEntry : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
