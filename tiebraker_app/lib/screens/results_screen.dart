import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../services/decision_service.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = Provider.of<DecisionService>(context).currentResult;

    if (result == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Analysis Result', style: TextStyle(fontWeight: FontWeight.w800)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                // Replaced surfaceVariant with surfaceContainerHighest
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: theme.colorScheme.primary,
                ),
                labelColor: theme.colorScheme.onPrimary,
                // Replaced onSurfaceVariant with onSurfaceVariant (though token naming is shifting)
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'Pros/Cons'),
                  Tab(text: 'Comparison'),
                  Tab(text: 'SWOT'),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Replaced withOpacity with withValues
                theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                theme.colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: TabBarView(
              children: [
                _MarkdownCard(data: result.prosAndCons),
                _MarkdownCard(data: result.comparisonTable),
                _MarkdownCard(data: result.swotAnalysis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarkdownCard extends StatelessWidget {
  final String data;
  const _MarkdownCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Markdown(
          data: data,
          styleSheet: MarkdownStyleSheet(
            h1: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            h2: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            p: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            tableBorder: TableBorder.all(color: theme.colorScheme.outlineVariant, width: 1),
            tableCellsPadding: const EdgeInsets.all(12),
            tableHead: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}