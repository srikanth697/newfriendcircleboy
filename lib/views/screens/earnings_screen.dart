import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyEarningsScreen extends StatefulWidget {
  const MyEarningsScreen({super.key});

  @override
  State<MyEarningsScreen> createState() => _MyEarningsScreenState();
}

class _MyEarningsScreenState extends State<MyEarningsScreen> {
  bool isWithdrawalTab = false;
  DateTime? fromDate;
  DateTime? toDate;

  final coinIcon = Image.asset('assets/coins.png', height: 16);
  final walletIcon = Image.asset('assets/wallet.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Earnings", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Row(
            children: [
              coinIcon,
              const SizedBox(width: 4),
              const Text(
                '878078',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildSummaryCard(),

          const SizedBox(height: 16),
          _buildTabs(),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  "Showing Results 12 Jun to 16 Jun",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _showCustomDatePicker,
                  child: const Text(
                    "Custom Date",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List moved here after Custom Date
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Today',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              coinIcon,
              const SizedBox(width: 4),
              const Text(
                '878078',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _gradientTabButton("My Earnings", !isWithdrawalTab, () {
          setState(() => isWithdrawalTab = false);
        }),
        const SizedBox(width: 12),
        _gradientTabButton("My Withdrawals", isWithdrawalTab, () {
          setState(() => isWithdrawalTab = true);
        }),
      ],
    );
  }

  Widget _gradientTabButton(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
                )
              : null,
          border: Border.all(
            color: selected ? Colors.transparent : Colors.pink.shade200,
          ),
          borderRadius: BorderRadius.circular(20),
          color: selected ? null : Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFFFF00CC),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: isWithdrawalTab ? 3 : 6,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.pink.shade100,
                child: walletIcon,
                radius: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isWithdrawalTab
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Rs 2000",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "9:55 PM, 25 May",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              coinIcon,
                              const SizedBox(width: 4),
                              const Text("878078"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "9:55 PM , 25 May",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
              ),
              if (isWithdrawalTab)
                const Text(
                  "Successful",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomDatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["Today", "This Month", "Last Month"].map((
                      label,
                    ) {
                      return Text(
                        label,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  _buildDateField("From Date", fromDate, () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: fromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setModalState(() => fromDate = picked);
                  }),

                  const SizedBox(height: 12),

                  _buildDateField("To Date", toDate, () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: toDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setModalState(() => toDate = picked);
                  }),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF00CC), Color(0xFF9A00F0)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Set Date",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            child: Text(
              date != null ? DateFormat('dd MMM yyyy').format(date) : '',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
