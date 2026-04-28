import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/themes/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/repositories/music_repository.dart';
import 'data/services/audio_service.dart';
import 'presentation/blocs/music/music_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppRouter.init();

  runApp(const OneDApp());
}

class OneDApp extends StatelessWidget {
  const OneDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AudioService()),
        RepositoryProvider(create: (_) => MusicRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MusicBloc(
              audioService: context.read<AudioService>(),
              musicRepository: context.read<MusicRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'OneD',
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
