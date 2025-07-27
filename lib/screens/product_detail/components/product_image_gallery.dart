import 'package:e_commerece_website_testing/screens/product_detail/components/components.dart';
import 'package:e_commerece_website_testing/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductImageGallery extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final Function(int) onImageChanged;
  final Animation<double> animation;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onImageChanged,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Column(
        children: [
          _buildMainImage(context),
          if (images.length > 1) ...[
            const SizedBox(height: 16),
            _buildThumbnails(),
          ],
        ],
      ),
    );
  }

  Widget _buildMainImage(BuildContext context) {
    return Container(
      height: Responsive.isMobile(context) ? 300 : 500,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(selectedIndex),
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(images[selectedIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            _buildImageIndicators(),
            _buildZoomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageIndicators() {
    if (images.length <= 1) return const SizedBox.shrink();
    
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(images.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: selectedIndex == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildZoomButton(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          onPressed: () => _showImageViewer(context),
          icon: const Icon(Icons.zoom_in, color: Colors.white),
          tooltip: 'View full size',
        ),
      ),
    );
  }

  Widget _buildThumbnails() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onImageChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageViewer(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => ImageViewerDialog(
        images: images,
        initialIndex: selectedIndex,
      ),
    );
  }
}