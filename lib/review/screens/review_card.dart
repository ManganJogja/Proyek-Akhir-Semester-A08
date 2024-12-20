// ReviewCard.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewCard extends StatefulWidget {
  final String username;
  final int rating;
  final String reviewText;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool canEdit;

  const ReviewCard({
    Key? key,
    required this.username,
    required this.rating,
    required this.reviewText,
    required this.date,
    required this.onEdit,
    required this.onDelete,
    this.canEdit = true,
  }) : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
          _controller.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE7DBC6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFF7C4D41),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.username,
                            style: GoogleFonts.mulish(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF3E190E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.reviewText,
                        style: GoogleFonts.mulish(
                          fontSize: 14,
                          color: const Color(0xFF3E190E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Posted on ${_formatDate(widget.date)}',
                        style: GoogleFonts.mulish(
                          fontSize: 12,
                          color: const Color(0xFF7C4D41),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  if (widget.canEdit)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAnimatedIconButton(
                            Icons.edit,
                            widget.onEdit,
                          ),
                          _buildAnimatedIconButton(
                            Icons.delete,
                            widget.onDelete,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedIconButton(IconData icon, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF3E190E)),
        onPressed: onPressed,
        hoverColor: const Color(0xFFDAC0A3).withOpacity(0.3),
        splashColor: const Color(0xFFDAC0A3).withOpacity(0.5),
      ),
    );
  }
}