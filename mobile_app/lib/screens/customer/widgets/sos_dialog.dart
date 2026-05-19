import 'package:flutter/material.dart';

/// A dialog that allows the customer to trigger an emergency SOS.
class SOSDialog extends StatefulWidget {
  final Future<bool> Function(bool shareWithPolice, String notes) onSubmit;

  const SOSDialog({super.key, required this.onSubmit});

  @override
  State<SOSDialog> createState() => _SOSDialogState();
}

class _SOSDialogState extends State<SOSDialog> {
  final _notesController = TextEditingController();
  bool _shareWithPolice = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Emergency SOS'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This will share your live location with your emergency flow immediately.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Location prepared: 33.6844, 73.0479'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _shareWithPolice,
              activeColor: Colors.red,
              title: const Text('Share with police'),
              subtitle: const Text('Keep this on for the highest-priority escalation.'),
              onChanged: (value) => setState(() => _shareWithPolice = value),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Emergency note',
                hintText: 'E.g. unsafe behavior, wrong route, harassment',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, 
            foregroundColor: Colors.white,
          ),
          onPressed: _isSubmitting
              ? null
              : () async {
                  setState(() => _isSubmitting = true);
                  final success = await widget.onSubmit(
                    _shareWithPolice,
                    _notesController.text.trim(),
                  );
                  
                  if (!mounted) return;
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: success ? Colors.red : null,
                      content: Text(
                        success
                            ? 'SOS triggered. Your live location has been shared with your emergency flow.'
                            : 'Failed to trigger SOS.',
                      ),
                    ),
                  );
                },
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Send SOS'),
        ),
      ],
    );
  }
}
