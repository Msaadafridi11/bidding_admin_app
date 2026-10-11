import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bidding_admin/core/theme/app_theme.dart';
import 'package:bidding_admin/core/widgets/custom_button.dart';
import 'package:bidding_admin/core/widgets/custom_card.dart';
import 'package:bidding_admin/core/widgets/status_chip.dart';

void main() {
  testWidgets('Core UI widgets render cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Column(
            children: [
              CustomButton(
                label: 'Test Button',
                onPressed: () {},
              ),
              const CustomCard(
                child: Text('Card Content'),
              ),
              StatusChip.verified(label: 'Verified Status'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
    expect(find.text('Card Content'), findsOneWidget);
    expect(find.text('Verified Status'), findsOneWidget);
  });
}
