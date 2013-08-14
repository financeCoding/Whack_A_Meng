part of whack_a_meng;

class Hole extends Sprite {
  Random _random = new Random();
  
  ResourceManager _resourceManager;
  BitmapData _whack;
  BitmapData _awesome;
  BitmapData _great;
  
  Sprite _overlay;
  Sprite _meng;
  
  bool _isActive = false;
  
  Hole(this._resourceManager) {
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("hole"));
    Bitmap foreground = new Bitmap(_resourceManager.getBitmapData("hole_over"));
    
    addChild(background);
    
    _overlay = new Sprite()
        ..addChild(foreground)
        ..mouseEnabled = false;
            
    _whack = _resourceManager.getBitmapData("whack");
    _awesome = _resourceManager.getBitmapData("awesome");
    _great = _resourceManager.getBitmapData("great");
    
    _meng = new Sprite()
        ..addChild(new Bitmap(_resourceManager.getBitmapData("meng")))
        ..onMouseClick.listen(_onMouseClick)
        ..x = 5
        ..y = 15;    
    
    this.onEnterFrame.listen(_onEnterFrame);
  }
  
  _onMouseClick(MouseEvent evt) {
    Bitmap whack = new Bitmap(_whack);
    whack.x = evt.localX - _whack.width / 2;
    whack.y = evt.localY - _whack.height / 2;
    
    addChild(whack);
    
    new Timer(new Duration(milliseconds : 300), () => removeChild(whack));
  }
  
  _onEnterFrame(EnterFrameEvent evt) {
    if (!_isActive && _random.nextInt(100) < 1) {
      addChild(_meng);
      addChild(_overlay);
      
      var tween = new Tween(_meng, 0.5)
        ..animate.x.to(-15);
      stage.juggler.add(tween);          
      
      _isActive = true;
      
      new Timer(new Duration(seconds : 2), () {
        var tween = new Tween(_meng, 0.2)
          ..animate.x.to(5)
          ..onComplete = () {
            removeChild(_meng);
            removeChild(_overlay);
            _isActive = false;
          };
        stage.juggler.add(tween);
      });
    }
  }
}