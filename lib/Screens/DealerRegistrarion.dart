import 'package:bidding_admin/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dealerregistrarion extends StatefulWidget {
  final UserModel? dealerData;
  const Dealerregistrarion({super.key, this.dealerData});

  @override
  State<Dealerregistrarion> createState() => _DealerregistrarionState();
}

class _DealerregistrarionState extends State<Dealerregistrarion> {
  bool isApproving = false;
  bool isRejecting = false;

  String? get dealerUid => widget.dealerData?.uid;

  void _confirmAction(String action, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$action Dealer?"),
        content: Text("Are you sure you want to $action this dealer request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  // ---------------- APPROVE ----------------
  Future<void> _approveDealer() async {
    if (dealerUid == null || dealerUid!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Dealer UID is missing.")),
        );
      }
      return;
    }

    setState(() {
      isApproving = true;
      isRejecting = false;
    });

    try {
      await FirebaseFirestore.instance
          .collection('userModel')
          .doc(dealerUid)
          .update({'isVerified': true});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dealer Approved Successfully!")),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      debugPrint("Approve error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to approve dealer: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isApproving = false);
      }
    }
  }

  // ---------------- REJECT ----------------
  Future<void> _rejectDealer() async {
    if (dealerUid == null || dealerUid!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Dealer UID is missing.")),
        );
      }
      return;
    }

    setState(() {
      isRejecting = true;
      isApproving = false;
    });

    try {
      await FirebaseFirestore.instance
          .collection('userModel')
          .doc(dealerUid)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dealer Request Rejected")),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      debugPrint("Reject error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to reject dealer: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isRejecting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dealerData == null) {
      return const Scaffold(
        body: Center(child: Text("No Dealer Data Found")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Verify Dealer"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.verified_user_rounded,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 10),
            Text(
              "Review Dealer Details",
              style: GoogleFonts.aBeeZee(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            _infoRow("Name", widget.dealerData!.name ?? "N/A"),
            const SizedBox(height: 20),
            _infoRow("Email", widget.dealerData!.email ?? "N/A"),

            const SizedBox(height: 80),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  label: "Approve",
                  icon: Icons.check_circle,
                  color: Colors.green,
                  isLoading: isApproving,
                  onTap: (isApproving || isRejecting)
                      ? null
                      : () => _confirmAction("Approve", _approveDealer),
                ),
                _actionButton(
                  label: "Reject",
                  icon: Icons.cancel,
                  color: Colors.red,
                  isLoading: isRejecting,
                  onTap: (isApproving || isRejecting)
                      ? null
                      : () => _confirmAction("Reject", _rejectDealer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- INFO ROW ----------------
  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label:',
          style: GoogleFonts.hanaleiFill(fontSize: 18),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.b612(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ---------------- ACTION BUTTON ----------------
  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return Column(
      children: [
        isLoading
            ? const CircularProgressIndicator()
            : IconButton(
                icon: Icon(icon, color: color, size: 70),
                onPressed: onTap,
              ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.b612(fontSize: 18, color: color),
        ),
      ],
    );
  }
}
