import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/utils/add_images.dart';
import 'package:flutter_carpooling/src/providers/ui_provider.dart';

class GalleryPage extends StatefulWidget {

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with SingleTickerProviderStateMixin {

  int _imageSelected;
  int _currentPage = 0;
  int _currentCategory = 0;

  AddImage _addImage;
  PageController _pageCtrl;
  AnimationController _animationCtrl;

  @override
  void initState() {
    _addImage = AddImage();
    _pageCtrl = PageController(initialPage: 0);
    _animationCtrl = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    if (_addImage.listPath.length == 0) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(responsive.hp(6.0)),
        child: AppBar(
          backgroundColor: OurColors.initialPurple,
          titleSpacing: 0,
          title: InkWell(
            onTap: () => _handleChangePage(),
            child: Row(
              children: [
                Text(_addImage.listPath[_currentCategory].folderName.isEmpty ? 'Galería' : _addImage.listPath[_currentCategory].folderName, style: TextStyle(fontSize: responsive.ip(2.2), fontFamily: 'WorkSansRegular', color: Colors.white)),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_animationCtrl),
                  child: Icon(Icons.arrow_drop_down, size: responsive.ip(2.6), color: Colors.white),
                ),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, size: responsive.ip(2.4))
          ),
          actions: [
            _imageSelected != null 
            ? Consumer<UIProvider>(builder: (context, provider, child) {
              return InkWell(
                onTap: () {
                  provider.image = _addImage.listPath[_currentCategory].files[_imageSelected];
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    SizedBox(width: 15.0),
                    Text('Siguiente', style: TextStyle(fontSize: responsive.ip(2.0), fontFamily: 'WorkSansRegular', color: Colors.white)),
                    SizedBox(width: 15.0)
                  ],
                ),
              );
            })
            : Container()
          ],
        ),
      ),
      body: PageView(
        controller: _pageCtrl,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        children: [
          GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _addImage.listPath[_currentCategory].files.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2
            ),
            padding: EdgeInsets.all(0.0),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () => _handleImageSelected(index),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: OurColors.gray,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        File(_addImage.listPath[_currentCategory].files[index]),
                        cacheWidth: 150,
                        cacheHeight: 150,
                        fit: BoxFit.contain,
                      ),
                      _imageSelected == index 
                      ? Icon(Icons.check_circle, size: responsive.ip(6.0), color: OurColors.lightGreenishBlue)
                      : Container()
                    ],
                  )
                ),
              );
            }
          ),
          ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _addImage.listPath.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  _handleCategory(index);
                  _handleChangePage();
                },
                title: Text(_addImage.listPath[index].folderName, style: TextStyle(fontSize: responsive.ip(2.0), fontFamily: '${_currentCategory != index ? "WorkSansRegular" : "WorkSansMedium"}')),
                leading: Text('${_addImage.listPath[index].files.length}', style: TextStyle(fontSize: responsive.ip(2.0), fontFamily: '${_currentCategory != index ? "WorkSansRegular" : "WorkSansMedium"}')),
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(_addImage.listPath[index].files[0]),
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                )
              );
            },
          )
        ],
      )
    );
  }

  void _handleChangePage() {
    if (_currentPage == 0) {
      setState(() {
        _currentPage = 1;
      });
      _animationCtrl.forward();
    } else {
      setState(() {
        _currentPage = 0;
      });
      _animationCtrl.reverse();
    }
    _pageCtrl.animateToPage(_currentPage, duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  void _handleCategory(int index) {
    if (_currentCategory != index) {
      setState(() {
        _imageSelected = null;
        _currentCategory = index;
      });  
    }
  }

  void _handleImageSelected(int index) {
    setState(() {
      _imageSelected = _imageSelected == index ? null : index;
    });
  }

}