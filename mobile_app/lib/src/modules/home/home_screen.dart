import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../common_widgets/job_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facility Marketplace'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, child) {
          if (jobProvider.isLoading && jobProvider.jobs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (jobProvider.errorMessage != null && jobProvider.jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${jobProvider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: jobProvider.fetchJobs,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (jobProvider.jobs.isEmpty) {
            return RefreshIndicator(
              onRefresh: jobProvider.fetchJobs,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No jobs available right now.'),
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: jobProvider.fetchJobs,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: jobProvider.jobs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final job = jobProvider.jobs[index];
                return JobCard(job: job);
              },
            ),
          );
        },
      ),
    );
  }
}
