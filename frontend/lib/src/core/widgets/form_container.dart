import 'package:flutter/material.dart';
import 'background_image.dart';

class FormContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final String? backgroundImage;
  final PreferredSizeWidget? appBar;

  const FormContainer({
    super.key,
    required this.child,
    this.maxWidth = 400.0,
    this.backgroundImage,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (backgroundImage != null)
            Positioned.fill(
              child: BackgroundImage(image: backgroundImage!),
            ),
          //WaveBackground(),
          SafeArea(
            top: false,
            child: Center(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth > maxWidth
                        ? maxWidth
                        : constraints.maxWidth;
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width),
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
