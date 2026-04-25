import 'package:flutter/material.dart';

/// A shimmer loading widget that displays a placeholder animation
/// while content is being loaded.
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = 24,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 0.3, 0),
              end: Alignment(_animation.value + 0.3, 0),
              colors: [
                Theme.of(context).colorScheme.surfaceContainerHighest,
                Theme.of(context).colorScheme.surfaceContainerHigh,
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Hino card shimmer placeholder
class HinoCardShimmer extends StatelessWidget {
  const HinoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 16,
                  child: Container(),
                ),
                const SizedBox(height: 8),
                ShimmerLoading(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 12,
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List of shimmer cards for loading state
class ShimmerList extends StatelessWidget {
  final int itemCount;

  const ShimmerList({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const HinoCardShimmer(),
    );
  }
}