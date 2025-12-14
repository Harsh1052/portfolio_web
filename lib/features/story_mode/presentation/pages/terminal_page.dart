import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../../data/datasources/story_data_source.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/repositories/story_repository.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import '../widgets/system_log_widget.dart';
import '../widgets/data_payload_widget.dart';

@RoutePage()
class TerminalPage extends StatelessWidget {
  const TerminalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Injecting dependencies here for now
    // Ideally this goes into a global DI setup
    return RepositoryProvider<StoryRepository>(
      create: (context) => StoryRepositoryImpl(StoryDataSource()),
      child: BlocProvider(
        create: (context) => StoryBloc(
          context.read<StoryRepository>(),
        )..add(StoryStarted()),
        child: const Scaffold(
          body: _TerminalLayout(),
        ),
      ),
    );
  }
}

class _TerminalLayout extends StatelessWidget {
  const _TerminalLayout();

  @override
  Widget build(BuildContext context) {
    // Basic responsive check
    final isDesktop = MediaQuery.of(context).size.width > 800;

    if (isDesktop) {
      return Row(
        children: [
          const Expanded(
            flex: 1,
            child: SystemLogWidget(),
          ),
          Container(
              width: 1, color: const Color(0xFF00FF41)), // Vertical Divider
          const Expanded(
            flex: 1,
            child: DataPayloadWidget(),
          ),
        ],
      );
    }

    // Mobile Layout
    return Column(
      children: [
        const Expanded(
          flex: 1,
          child: SystemLogWidget(),
        ),
        Container(height: 1, color: const Color(0xFF00FF41)),
        const Expanded(
          flex: 1,
          child: DataPayloadWidget(),
        ),
      ],
    );
  }
}
