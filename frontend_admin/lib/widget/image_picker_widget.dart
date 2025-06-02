import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    this.initialImageUrl,
    required this.onImageSelected,
    required this.onImageCleared,
  });

  final String? initialImageUrl;
  final void Function(Uint8List imageBytes, String fileName) onImageSelected;
  final VoidCallback onImageCleared;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hình ảnh sản phẩm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: _buildImageContent(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickImage,
              icon:
                  _isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.image),
              label: Text(_isLoading ? 'Đang tải...' : 'Chọn ảnh'),
            ),
            const SizedBox(width: 8),
            if (_selectedImageBytes != null || widget.initialImageUrl != null)
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _clearImage,
                icon: const Icon(Icons.clear),
                label: const Text('Xóa ảnh'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageContent() {
    if (_selectedImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      );
    }

    if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.initialImageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
              ),
            );
          },
        ),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text('Chưa có ảnh được chọn', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(height: 4),
        Text('Nhấn "Chọn ảnh" để tải lên', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false, withData: true);

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          setState(() {
            _selectedImageBytes = file.bytes;
          });
          widget.onImageSelected(file.bytes!, file.name);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi chọn ảnh: $e'), backgroundColor: Colors.red));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImageBytes = null;
    });
    widget.onImageCleared();
  }
}
