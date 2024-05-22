import 'package:flutter/material.dart';

// TODO: Find a way to make image take up same size as the tallest image

class PostImageGallery extends StatefulWidget {
  final List<String> imageStrings;
  static const maxHeight = 720.0;

  const PostImageGallery({ super.key, required this.imageStrings });

  @override
  State<PostImageGallery> createState() => _PostImageGalleryState();
}

class _PostImageGalleryState extends State<PostImageGallery> {
  int pageIndex = 0;
  var controller = PageController( 
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    int numImages = widget.imageStrings.length; 

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 500.0,
          child: PageView.builder( 
            itemCount: numImages,
            controller: controller,
            onPageChanged: (value) {
              setState(() {
                pageIndex = value;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    color: Colors.grey[400],
                    child: Image( 
                      fit: BoxFit.fitHeight, 
                      image: AssetImage(widget.imageStrings[index]),
                      errorBuilder: (context, error, stackTrack) => const SizedBox.shrink(),
                    ),
                  )
                ),
              );
            },   
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
          child: Container( 
            decoration: BoxDecoration( 
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey[800],
            ),
            height: 15.0,
            width: 15.0 * numImages + 6.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                for (var index = 0; index < numImages; index++)
                  SizedBox(
                    height: 15.0,
                    width: 12.0,
                    child: IconButton(
                      iconSize: 10,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.circle,
                        color: index == pageIndex
                          ? Colors.white
                          : Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          pageIndex = index;
                          controller.animateToPage(
                            index,
                            duration:  const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        });
                      }
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}