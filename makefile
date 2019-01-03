# thanks to  URIN HACK
# https://urin.github.io/posts/2013/simple-makefile-for-clang
COMPILER  = clang++
CFLAGS    = -g -MMD -O3 -MP -Wall -Wextra -Winit-self -Wno-missing-field-initializers -fopenmp
ifeq "$(shell getconf LONG_BIT)" "64"
	  LDFLAGS = -lboost_system
  else
	  LDFLAGS = -lboost_system
  endif
  LIBS      =
  INCLUDE   = -I./include
  TARGET    = ../bin/$(shell basename `readlink -f .`)
  SRCDIR    = ../src
  ifeq "$(strip $(SRCDIR))" ""
	  SRCDIR  = .
  endif
  SOURCES   = $(wildcard $(SRCDIR)/*.cpp)
  OBJDIR    = ../obj
  ifeq "$(strip $(OBJDIR))" ""
	  OBJDIR  = .
  endif
OBJECTS   = $(addprefix $(OBJDIR)/, $(notdir $(SOURCES:.cpp=.o)))
	DEPENDS   = $(OBJECTS:.o=.d)

$(TARGET): $(OBJECTS) $(LIBS)
		$(COMPILER) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
		-mkdir -p $(OBJDIR)
		$(COMPILER) $(CFLAGS) $(INCLUDE) -o $@ -c $<

all: clean $(TARGET)

clean:
		-rm -f $(OBJECTS) $(DEPENDS) $(TARGET)
run: $(TARGET)
	$(TARGET)
sim: $(TARGET)
	$(TARGET) 0 0 0
debug: $(TARGET)
	$(TARGET) 0 0 0 0
-include $(DEPENDS)
