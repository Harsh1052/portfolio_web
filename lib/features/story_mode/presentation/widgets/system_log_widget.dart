import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/terminal_theme.dart';
import '../../domain/entities/story_node.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_state.dart';
import 'terminal_typer.dart';

class SystemLogWidget extends StatelessWidget {
  const SystemLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Auto-scroll logic could be added here with a ScrollController

    return Container(
      color: TerminalTheme.voidBlack,
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          return ListView.separated(
            itemCount: state.log.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final node = state.log[index];
              final isLast = index == state.log.length - 1;
              return _buildNode(node, isLast);
            },
          );
        },
      ),
    );
  }

  Widget _buildNode(StoryNode node, bool isLast) {
    // Define style based on type
    TextStyle style;
    String prefix = '';

    if (node.type == StoryNodeType.system) {
      prefix = '> [SYSTEM] ';
      style = TerminalTheme.terminalText.copyWith(color: TerminalTheme.dimText);
    } else if (node.type == StoryNodeType.command) {
      prefix = '> ';
      style = TerminalTheme.terminalText.copyWith(
          color: TerminalTheme.neonGreen, fontWeight: FontWeight.bold);
    } else {
      style =
          TerminalTheme.terminalText.copyWith(color: TerminalTheme.cyberBlue);
    }

    final fullText = '$prefix${node.text}';

    if (isLast) {
      return DefaultTextStyle(
        style: style,
        child: TerminalTyper(
          text: fullText,
          speed: const Duration(milliseconds: 30),
        ),
      );
    }

    return Text(fullText, style: style);
  }
}
