import 'package:flutter/material.dart';
import 'package:gastrohub_app/src/core/themes/app_theme.dart';

class FormContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final String? backgroundImage;

  const FormContainer({
    super.key,
    required this.child,
    this.maxWidth = 400.0,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (backgroundImage != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth > maxWidth
                        ? maxWidth
                        : constraints.maxWidth;
                    return Container(
                      width: width,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor.withAlpha(220),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
