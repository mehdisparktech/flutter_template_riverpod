import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../models/api_error/api_error.dart';
import '../../../theme/theme.dart';
import '../controllers/home_notifier.dart';
import '../controllers/home_state.dart';
import '../widgets/movie_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: Text(
          'appName'.tr(),
          style: AppTextStyles.bold,
        ),
      ),
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: homeState.when(
              data: (data) => HomePageContents(state: data),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.secondary),
                ),
              ),
              error: (e, __) => Text(
                e is ApiError ? e.message : e.toString(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePageContents extends ConsumerWidget {
  const HomePageContents({
    required this.state,
    super.key,
  });

  final HomeState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) => RefreshIndicator(
        displacement: 10,
        backgroundColor: AppColors.white,
        color: AppColors.primary,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverToBoxAdapter(
              child: PaginationWidget(state: state),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 180,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 3,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: MovieWidget(movie: state.movies[index]),
                      ),
                    ),
                  ),
                  childCount: state.movies.length,
                ),
              ),
            ),
          ],
        ),
      );
}

class PaginationWidget extends ConsumerWidget {
  const PaginationWidget({
    required this.state,
    super.key,
  });

  final HomeState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: state.page == 1 ? 0.2 : 1,
            child: IconButton(
              onPressed: () {
                if (state.page > 1) {
                  ref
                      .read(homeNotifierProvider.notifier)
                      .setPage(state.page - 1);
                }
              },
              icon: const Icon(Icons.chevron_left),
            ),
          ),
          Text('${state.page} ... ${state.totalPages}'),
          Opacity(
            opacity: state.page == state.totalPages ? 0.2 : 1,
            child: IconButton(
              onPressed: () {
                if (state.page < state.totalPages) {
                  ref
                      .read(homeNotifierProvider.notifier)
                      .setPage(state.page + 1);
                }
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      );
}
