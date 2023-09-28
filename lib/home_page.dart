import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:huevos/acciones/camara.dart';
import 'package:huevos/acciones/selec.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? sele_img;
  Dio dio = Dio();
  Future<void> subir(sele_img) async {
    try {
      String filename = sele_img!.path.split('/').last;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(sele_img!.path,
            filename: filename, contentType: MediaType('image', 'jpeg'))
      });
      await dio
          .post('https://aedes-69n6.onrender.com/subir',
              data: formData,
              options: Options(headers: {
                "accept": '*/*',
                'ContentType': "multipart/form-data"
              }))
          .then((response) => print(response))
          .catchError((error) => print(error));
      print("Se subió sin problemas");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              scale: 12,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Ovitraapp',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          sele_img != null
              ? Image.file(sele_img!)
              : Container(
                  margin: const EdgeInsets.all(20),
                  height: 200,
                  width: double.infinity,
                  color: Color.fromARGB(179, 54, 54, 54),
                ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.yellow),
              onPressed: () async {
                final cama = await getImageC();
                if (cama != null) {
                  CroppedFile? croppedFile = await ImageCropper().cropImage(
                    sourcePath: cama.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Dimensionando para Análisis',
                          toolbarColor: Colors.deepOrange,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        title: 'Dimensionando Imagen',
                      ),
                    ],
                  );
                  if (croppedFile != null) {
                    setState(() {
                      sele_img = File(croppedFile.path);
                    });
                  }
                  subir(sele_img);
                }
              },
              child: const Text(
                "Tomar Foto",
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.yellow),
              onPressed: () async {
                final simagen = await getImage();
                if (simagen != null) {
                  CroppedFile? croppedFile = await ImageCropper().cropImage(
                    sourcePath: simagen.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Dimensionando para Análisis',
                          toolbarColor: Colors.deepOrange,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        title: 'Dimensión de Imagen',
                      ),
                    ],
                  );
                  if (croppedFile != null) {
                    setState(() {
                      sele_img = File(croppedFile.path);
                    });
                  }
                }
              },
              child: const Text("Seleccionar Imagen")),
          //ElevatedButton(
            //style: ElevatedButton.styleFrom(
              //  backgroundColor: Colors.red, foregroundColor: Colors.yellow),
            //onPressed: () async {
              //subir();
            //},
            //child: const Text("Subir Imagen para su Análisis"),
          //),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey)),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal:15),
            child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Ingresa el nombre de la imagen resultante',
                    border: InputBorder.none)),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.yellow),
              onPressed: () {},
              child: const Text("Recibir imagen de Resultados")),
        ],
      ),
    );
  }
}
