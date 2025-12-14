import 'package:flutter/material.dart';
import '../../../../core/theme/terminal_theme.dart';
import '../../../../models/experience.dart';
import 'holo_card.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;

  const ExperienceCard({super.key, required this.experience});

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
                'EXPERIENCE_NODE_DETECTED',
                style: TerminalTheme.terminalDim,
              ),
              const Icon(Icons.work_outline, color: TerminalTheme.neonGreen),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            experience.position,
            style: TerminalTheme.terminalHeader,
          ),
          const SizedBox(height: 8),
          Text(
            '${experience.company} @ ${experience.location}',
            style: TerminalTheme.terminalText.copyWith(
              color: TerminalTheme.cyberBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${experience.startDate} - ${experience.endDate}',
            style: TerminalTheme.terminalDim,
          ),
          const SizedBox(height: 16),
          const Divider(color: TerminalTheme.neonGreen),
          const SizedBox(height: 16),
          ...experience.responsibilities.map((resp) => HoloBullet(resp)),
          const SizedBox(height: 16),
          if (experience.technologies != null)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: experience.technologies!
                  .map((tech) => Chip(
                        label: Text(
                          tech,
                          style: TerminalTheme.terminalText.copyWith(
                              fontSize: 12, color: TerminalTheme.voidBlack),
                        ),
                        backgroundColor: TerminalTheme.neonGreen,
                        padding: const EdgeInsets.all(0),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
