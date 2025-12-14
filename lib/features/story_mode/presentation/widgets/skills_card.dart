import 'package:flutter/material.dart';
import '../../../../core/theme/terminal_theme.dart';
import '../../../../models/skill.dart';
import 'holo_card.dart';

class SkillsCard extends StatelessWidget {
  final List<SkillCategory> skills;

  const SkillsCard({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return HoloCard(
      borderColor: TerminalTheme.cyberBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SYSTEM_CAPABILITIES_LIST',
                style: TerminalTheme.terminalDim,
              ),
              const Icon(Icons.memory, color: TerminalTheme.cyberBlue),
            ],
          ),
          const SizedBox(height: 16),
          ...skills.map((category) => _buildCategory(category)),
        ],
      ),
    );
  }

  Widget _buildCategory(SkillCategory category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.name,
              style: TerminalTheme.terminalHeader.copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.skills
                .map((skill) => Chip(
                      label: Text(
                        skill.name,
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
