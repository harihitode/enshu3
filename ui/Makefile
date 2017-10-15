CXX=clang -Wall -framework Cocoa -framework OpenGL -framework CoreGraphics -framework QuartzCore
OBJECTS=ui.o poseView.o medal.o circle.o triangle.o oresen.o
TARGET=ui

$(TARGET): $(OBJECTS)
	$(CXX) -o $(TARGET) $(OBJECTS)
clean:
	rm -rf *.o *~ $(TARGET)
