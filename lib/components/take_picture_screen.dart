import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nets_core/components/widgets/buttons.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final String title;
  final void Function(File)? onPictureTaken;
  const TakePictureScreen(
      {super.key, required this.camera, this.title = '', this.onPictureTaken});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  CameraDescription? camera;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title == '' ? 'Take a picture' : widget.title)),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                  onPictureTaken: widget.onPictureTaken,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final void Function(File)? onPictureTaken;
  final String imagePath;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, this.onPictureTaken});

  @override
  Widget build(BuildContext context) {
    var trans = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(trans.picturePreview)),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: ListView(
          children: [
            Image.file(File(imagePath)),
            Column(
              children: [
                Container(
                    constraints: const BoxConstraints(maxWidth: 330),
                    child: Column(
                      children: [
                        WideButton(
                            color: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            icon: const Icon(Icons.camera_alt),
                            label: trans.retakePicture,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        WideButton(
                            icon: const Icon(Icons.check),
                            label: trans.continueNext,
                            onPressed: () {
                              if (onPictureTaken != null) {
                                onPictureTaken!(File(imagePath));
                              }
                              Navigator.pop(context);
                            }),
                      ],
                    ))
              ],
            )
          ],
        ));
  }
}
