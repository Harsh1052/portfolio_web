import 'package:flutter/material.dart';
import '../../../../core/theme/terminal_theme.dart';
import '../../../../models/project.dart';
import 'holo_card.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

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
                'PROJECT_BLUEPRINT_LOADED',
                style: TerminalTheme.terminalDim,
              ),
              const Icon(Icons.code, color: TerminalTheme.cyberBlue),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.name,
            style: TerminalTheme.terminalHeader
                .copyWith(color: TerminalTheme.cyberBlue),
          ),
          const SizedBox(height: 16),
          Text(
            project.description,
            style: TerminalTheme.terminalText,
          ),
          const SizedBox(height: 16),
          const Divider(color: TerminalTheme.cyberBlue),
          const SizedBox(height: 16),
          if (project.features != null)
            ...project.features!.map((feat) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('+ ',
                          style: TerminalTheme.terminalText
                              .copyWith(color: TerminalTheme.cyberBlue)),
                      Expanded(
                        child: Text(
                          feat,
                          style: TerminalTheme.terminalText,
                        ),
                      ),
                    ],
                  ),
                )),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.technologies
                .map((tech) => Chip(
                      label: Text(
                        tech,
                        style: TerminalTheme.terminalText.copyWith(
                            fontSize: 12, color: TerminalTheme.voidBlack),
                      ),
                      backgroundColor: TerminalTheme.cyberBlue,
                      padding: const EdgeInsets.all(0),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
