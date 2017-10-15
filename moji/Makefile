CXX=clang -Wall -framework Cocoa -framework OpenGL -framework CoreGraphics -framework QuartzCore
OBJECTS=katarina.o view.o tokenView.o tokenCeller.o tokenRender.o tokenLRender.o strokeRefiner.o stroke.o strokeArray.o token.o tokenGenerater.o randomNumber.o
TARGET=Enshu3.app

$(TARGET): $(OBJECTS)
	$(CXX) -o Enshu3 $(OBJECTS)
	mkdir -p "Enshu3.app/Contents/MacOS"
	cp Info.plist Enshu3.app/Contents/MacOS
	cp Enshu3 Enshu3.app/Contents/MacOS/
clean:
	rm -rf *.o *~ Enshu3 Enshu3.app
