import 'package:flutter/material.dart';

/// Reusable dialog for reporting an issue with a completed job.
class ReportIssueDialog extends StatefulWidget {
  final Future<bool> Function(String description) onSubmit;

  const ReportIssueDialog({super.key, required this.onSubmit});

  @override
  State<ReportIssueDialog> createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report Issue'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Describe the dispute or safety issue from this completed job.'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Explain what went wrong...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  setState(() => _isSubmitting = true);
                  final success = await widget.onSubmit(_controller.text);
                  if (context.mounted && success) {
                    Navigator.pop(context, true);
                  } else if (context.mounted) {
                    setState(() => _isSubmitting = false);
                  }
                },
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Submit Report'),
        ),
      ],
    );
  }
}
