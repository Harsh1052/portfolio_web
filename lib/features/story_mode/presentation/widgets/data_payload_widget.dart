import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/terminal_theme.dart';
import '../../../../models/resume.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_state.dart';
import 'education_card.dart';
import 'experience_card.dart';
import 'skills_card.dart';

import 'holo_card.dart';

class DataPayloadWidget extends StatelessWidget {
  const DataPayloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          TerminalTheme.voidBlack.withValues(alpha: 0.95), // Slightly lighter
      padding: const EdgeInsets.all(24),
      child: Center(
        child: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            final resume = state.resume as Resume?;
            final id = state.activePayloadId;

            if (resume == null || id == null) {
              return Text(
                'WAITING FOR DATA STREAM...',
                style: TerminalTheme.terminalWarning,
              );
            }

            switch (id) {
              case 'CH1_IDENTITY':
                return _buildBioCard(resume);

              case 'CH2_KERNEL':
                if (resume.education.isNotEmpty) {
                  return EducationCard(education: resume.education.first);
                }
                break;

              case 'CH3_SCALE':
                // Show Elision & Tagline (Indices 1 & 2)
                final exps = <Widget>[];
                if (resume.experience.length > 1) {
                  exps.add(ExperienceCard(experience: resume.experience[1]));
                }
                if (resume.experience.length > 2) {
                  exps.add(Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ExperienceCard(experience: resume.experience[2])));
                }

                if (exps.isNotEmpty) {
                  return SingleChildScrollView(child: Column(children: exps));
                }
                break;

              case 'CH4_MAINFRAME':
                // Show FarmSetu (Index 0)
                if (resume.experience.isNotEmpty) {
                  return ExperienceCard(experience: resume.experience[0]);
                }
                break;

              case 'CH5_INVENTORY':
                return SingleChildScrollView(
                    child: SkillsCard(skills: resume.skills));

              default:
                // Fallback for old IDs if necessary, or just generic message
                return Text('ENCRYPTED PAYLOAD: $id',
                    style: TerminalTheme.terminalDim);
            }

            return Text(
              'DATA NOT FOUND',
              style: TerminalTheme.terminalWarning,
            );
          },
        ),
      ),
    );
  }

  Widget _buildBioCard(Resume resume) {
    return HoloCard(
      borderColor: TerminalTheme.neonGreen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person, size: 64, color: TerminalTheme.neonGreen),
          const SizedBox(height: 16),
          Text(
            resume.personalInfo.name,
            style: TerminalTheme.terminalHeader,
          ),
          const SizedBox(height: 8),
          Text(
            resume.personalInfo.title,
            style: TerminalTheme.terminalText,
          ),
          const SizedBox(height: 8),
          Text(
            resume.personalInfo.location ?? 'Unknown Location',
            style: TerminalTheme.terminalDim,
          ),
          const SizedBox(height: 16),
          Text(
            resume.personalInfo.bio,
            textAlign: TextAlign.center,
            style: TerminalTheme.terminalText,
          ),
        ],
      ),
    );
  }
}
