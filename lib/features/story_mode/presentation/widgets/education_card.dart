import 'package:flutter/material.dart';
import '../../../../core/theme/terminal_theme.dart';
import '../../../../models/education.dart';
import 'holo_card.dart';

class EducationCard extends StatelessWidget {
  final Education education;

  const EducationCard({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return HoloCard(
      borderColor: TerminalTheme.neonGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACADEMIC_RECORD_FOUND',
                style: TerminalTheme.terminalDim,
              ),
              const Icon(Icons.school, color: TerminalTheme.neonGreen),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            education.degree,
            style: TerminalTheme.terminalHeader,
          ),
          const SizedBox(height: 8),
          Text(
            '${education.institution}, ${education.location ?? "Unknown"}',
            style: TerminalTheme.terminalText.copyWith(
              color: TerminalTheme.cyberBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${education.startDate} - ${education.endDate}',
            style: TerminalTheme.terminalDim,
          ),
          const SizedBox(height: 16),
          if (education.achievements != null)
            ...education.achievements!.map((ach) => HoloBullet(ach)),
          const SizedBox(height: 8),
          if (education.description != null)
            Text(
              education.description!,
              style: TerminalTheme.terminalText,
            ),
        ],
      ),
    );
  }
}
