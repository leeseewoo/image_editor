import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';



import '../component/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;

  Set<StickerModel> stickers = {};    //화면에 추가된 스티커를 저장할 변수
  String? selectedId;     // 현재 선택된 스티커의 ID
  GlobalKey imgKey = GlobalKey();    // 이지미로 전환할 위젯에 입력해줄 키값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          renderBody(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MainAppBar(
              // ➋ AppBar 위치하기
              onPickImage: onPickImage,
              onSaveImage: onSaveImage,
              onDeleteItem: onDeleteItem,
            ),
          ),
          if (image != null)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Footer(onEmoticonTap: onEmoticonTap))
        ],
      ),
    );
  }

  Widget renderBody() {
    if (image != null) {
      return RepaintBoundary(
        key: imgKey,
        child : Positioned.fill(
        child: InteractiveViewer(
          child: Stack(
            fit: StackFit.expand,   // 크기 최대로 늘려주기
            children: [
              Image.file(
                File(image!.path),
                fit: BoxFit.cover,    // 이미지 최대한 공간 차지하게 하기
              ),
              ...stickers.map(
                  (sticker) => Center(  // 최초 스티커 선택 시 중아에 배치
                    child: EmoticonSticker(
                      key: ObjectKey(sticker.id),
                      onTransform: () {
                        onTransform(sticker.id);
                      },
                      imgPath: sticker.imgPath,
                      isSelected: selectedId == sticker.id,
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
      );
    } else {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          onPressed: onPickImage,
          child: Text('이미지 선택하기'),
        ),
      );
    }
  }

  void onTransform(String id) {
    // 스티커가 변형될 때마다 변형 중인 스티커를 현재 선택한 스티커로 지정
    setState(() {
      selectedId = id;
    });
  }

  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() async {
    RenderRepaintBoundary boundary = imgKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    await ImageGallerySaver.saveImage(pngBytes, quality: 100);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('저장되었습니다.')),
    );

  }

  void onDeleteItem() {
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();
      // 현재 선택되 있는 스티커 삭제 후 Set로 변환
    });
  }

  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(),      // 스티커의 고유ID
          imgPath: 'asset/img/emoticon_$index.png',
        ),
      };
    });
  }
}
